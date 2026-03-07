# docker_lxc

This module bundles together all the necessary provisioning for cloning a pre-defined LXC with [Docker](https://www.docker.com/) installed.

## Necessary vars

- `lxc_template_vm_id`: The VM ID of the LXC Template.

- `ssh_public_key_path`: The SSH public key to be inserted into the `known_hosts` of the LXC for future Ansible configuration

- `container`: The container configuration. It includes information such as: 
    - `name`: The LXC name
    - `vm_id`: The VM ID to be given to the created LXC
    - `memory`: The RAM in MB to be given to the LXC
    - `disk_size`: The Disk space in GB to be given to the LXC
    - `tags`: The Proxmox tags (helps for future configuration by Ansible alongside [proxmoxer](https://github.com/proxmoxer/proxmoxer))
    - `password`: An optional password for the LXC
