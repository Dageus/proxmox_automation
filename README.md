# Fully replicable, automated Proxmox setup

## Creating a Docker template

This script is the most spaghetti IaC I have, but it works, so I won't mess with it.

It will start with:

1. Terraform provisioning the Docker LXC ([lxc_docker_template.tf](./terraform/lxc_docker_template.tf))

2. Ansible configuring it and cleaning up the container ([lxc_template.yml](./ansible/playbooks/lxc_template.yml))

3. Ansible calling back Terraform to fetch the LXC ID and convert it to a template ([lxc_convert_to_template.tf](./terraform/lxc_convert_to_template.tf))

## Ansible

To help with automation, some useful roles were created:

- [docker_service_deploy](./ansible/roles/docker_service_deploy/README.md)

- [lxc_mount](./ansible/roles/lxc_mount/README.md)

- [nfs_mount](./ansible/roles/nfs_mount/README.md)

- [proxmox_init](./ansible/roles/proxmox_init/README.md)

- [qemu_guest_agent](./ansible/roles/qemu_guest_agent/README.md)

### Unstable notes

- Ansible has an unmapped `proxmox_mapped_uid` in [`lxc_mount`](./ansible/roles/lxc_mount/tasks/main.yml)

## Terraform

To help with automation, a [module](https://developer.hashicorp.com/terraform/language/modules) was created to clone my custom Docker template: [docker_lxc](./terraform/modules/docker_lxc/README.md)

### Unstable notes

- `gpu_devices` in the [`docker_lxc`](./terraform/modules/docker_lxc/vars.tf) is an insane rawdog. If I change CPU's this might break.

- VM's are not well tackled yet (will get to it once the *arr stack is deployed)
