#!/bin/bash

# fail on error
set -e

# enable global variables
set -a

source .env

TF_DIR="terraform"
ANS_DIR="ansible"

echo "Starting Deployment Pipeline..."

echo "Initializing Terraform..."
terraform -chdir=$TF_DIR init

echo "Bootstrapping Proxmox..."
ansible-playbook $ANS_DIR/playbooks/bootstrap_proxmox.yml

echo "Provisioning the Base Docker LXC..."
terraform -chdir=$TF_DIR apply -target="proxmox_virtual_environment_container.docker_template" -auto-approve

echo "Installing Docker, Cleaning up and Templating..."
ansible-playbook $ANS_DIR/playbooks/lxc_template.yml --flush-cache

echo "Provisioning..."
terraform -chdir=$TF_DIR apply -parallelism=1 -auto-approve

echo "Waiting for resources to be provisioned..."
sleep 2

echo "Configuring Applications..."
ansible-playbook $ANS_DIR/playbooks/apps.yml

echo "Waiting for resources to be configured..."
sleep 2

echo "[TODO] Retrieve IPs for Reverse Proxy..."
# ansible-playbook $ANS_DIR/playbooks/configure_reverse_proxy.yml

echo "Pipeline Complete."
