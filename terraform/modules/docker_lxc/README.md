# docker_lxc

This module bundles together all the necessary provisioning for cloning a pre-defined LXC with [Docker](https://www.docker.com/) installed.

## Necessary vars

- `lxc_template_vm_id`: The VM ID of the LXC Template.

- `container`: The container configuration. It includes information such as:
    - `name`: The LXC name
    - `vm_id`: The VM ID to be given to the created LXC
    - `memory`: The RAM in MB to be given to the LXC
    - `disk_size`: The Disk space in GB to be given to the LXC
    - `tags`: The Proxmox tags (helps for future configuration by Ansible alongside [proxmoxer](https://github.com/proxmoxer/proxmoxer))
