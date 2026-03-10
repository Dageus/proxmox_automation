#!/bin/bash
set -e

echo "Starting Deployment Pipeline..."

# 1. Base LXC Creation
echo "Provisioning the Base Docker LXC..."
terraform -chdir=infrastructure/terraform apply -target="proxmox_virtual_environment_container.existing_docker_template" -auto-approve

# 2. Ansible Configuration
echo "Installing Docker and Cleaning up..."
# Grab the dynamically assigned ID from Terraform output
TEMPLATE_ID=$(terraform -chdir=infrastructure/terraform output -raw template_lxc_id)
# Run Ansible, passing the Vault password file and the target VMID
ansible-playbook infrastructure/ansible/lxc_template.yml --vault-password-file .vault_pass.txt -e "vmid=$TEMPLATE_ID"

# 3. Template Conversion
echo "Converting LXC to Proxmox Template..."
terraform -chdir=infrastructure/terraform apply -target="null_resource.convert_to_template" -auto-approve

# 4. Deploy the Rest of the Homelab
echo "Provisioning Applications (Nextcloud, Immich, etc.)..."
terraform -chdir=infrastructure/terraform apply -auto-approve

echo "Configuring Applications..."
ansible-playbook infrastructure/ansible/site.yml --vault-password-file .vault_pass.txt

echo "Pipeline Complete."

# Alternative

#!/bin/bash
# 1. Prep the Host (Mount NFS, create folders)
ansible-playbook -i inventory.ini host_prep.yml

# 2. Build the Infrastructure
terraform apply -auto-approve

# 3. Configure the Apps inside the containers
ansible-playbook -i proxmox.yaml deploy_apps.yml
