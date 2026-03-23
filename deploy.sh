#!/bin/bash
set -e

source .env

TF_DIR="terraform"
ANS_DIR="ansible"
APP_PATH="/workspace/services"

echo "Starting Deployment Pipeline..."

echo "Initializing Terraform..."
terraform -chdir=$TF_DIR init

echo "Bootstrapping Proxmox..."
ansible-playbook $ANS_DIR/playbooks/bootstrap_proxmox.yml

echo "[TODO] Provisioning VMs..."
terraform -chdir=$TF_DIR -target="proxmox_virtual_environment_vm" -auto-approve

echo "[TODO] Mount Host NFS share..."
ansible-playbook $ANS_DIR/playbooks/host_storage_prep.yml

echo "Provisioning the Base Docker LXC..."
terraform -chdir=$TF_DIR apply -target="proxmox_virtual_environment_container.docker_template" -auto-approve

echo "Installing Docker, Cleaning up and Templating..."
ansible-playbook $ANS_DIR/playbooks/lxc_template.yml --flush-cache

echo "Provisioning Applications..."
terraform -chdir=$TF_DIR apply -auto-approve

echo "Configuring Applications..."
ansible-playbook $ANS_DIR/playbooks/apps.yml

echo "[TODO] Retrieve IPs for Reverse Proxy..."
ansible-playbook $ANS_DIR/playbooks/configure_reverse_proxy.yml

echo "Pipeline Complete."
