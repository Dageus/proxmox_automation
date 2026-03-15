#!/bin/bash
set -e

source .env

TF_DIR="terraform"
ANS_DIR="ansible"
APP_PATH="/workspace/services"

echo "Starting Simple Deployment Pipeline..."

echo "Initializing Terraform..."
terraform -chdir=$TF_DIR init

echo "Bootstrapping Proxmox..."
ansible-playbook $ANS_DIR/playbooks/bootstrap_proxmox.yml

echo "Provisioning the Base Docker LXC..."
terraform -chdir=$TF_DIR apply -target="proxmox_virtual_environment_container.docker_template" -auto-approve

echo "Installing Docker, Cleaning up and Templating..."
ansible-playbook $ANS_DIR/playbooks/lxc_template.yml --flush-cache

echo "Provisioning Application..."
terraform -chdir=$TF_DIR apply -target="module.filebrowser" -auto-approve

echo "Configuring Application..."
ansible-playbook $ANS_DIR/playbooks/filebrowser.yml -e "app_config_path=$APP_PATH"

echo "Pipeline Complete."
