#!/bin/bash
set -e

echo "Starting Deployment Pipeline..."

echo "Bootstrapping Proxmox..."
ansible-playbook ansible/bootstrap_proxmox.yml

echo "[TODO] Provisioning VMs..."
terraform -chdir=terraform -target="proxmox_virtual_environment_vm" -auto-approve

echo "[TODO] Mount Host NFS share..."
ansible-playbook ansible/host_storage_prep.yml

echo "Provisioning the Base Docker LXC..."
terraform -chdir=terraform apply -target="proxmox_virtual_environment_container.docker_base" -auto-approve

echo "Installing Docker and Cleaning up..."
ansible-playbook infrastructure/ansible/lxc_template.yml

echo "Converting LXC to Proxmox Template..."
terraform -chdir=infrastructure/terraform apply -target="null_resource.convert_to_template" -auto-approve

echo "Provisioning Applications..."
terraform -chdir=infrastructure/terraform apply -auto-approve
terraform -chdir=terraform apply -auto-approve

echo "Configuring Applications..."
ansible-playbook infrastructure/ansible/apps.yml

echo "[TODO] Retrieve IPs for Reverse Proxy"
ansible-playbook ansible/configure_reverse_proxy.yml

echo "Pipeline Complete."
