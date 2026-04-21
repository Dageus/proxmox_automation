# Fully replicable, automated Proxmox setup

![Proxmox](https://img.shields.io/badge/proxmox-proxmox?style=for-the-badge&logo=proxmox&logoColor=%23E57000&labelColor=%232b2a33&color=%232b2a33)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Ansible](https://img.shields.io/badge/ansible-%231A1918.svg?style=for-the-badge&logo=ansible&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)

This is a complementary repo to my [homelab setup](https://github.com/Dageus/homelab) for automating my deployments and configurations.

## Running the docker runner

```
docker compose run --rm runner
```

### Preparing the Proxmox Host

Use:

```
ssh-copy-id -i /path/to/ssh-key root@<host_ip>
```

To add your SSH key to the known_hosts of the pve host.

## Ansible

To help with automation, some useful roles were created:

- [docker_service_deploy](./ansible/roles/docker_service_deploy/README.md)

- [lxc_mount](./ansible/roles/lxc_mount/README.md)

- [nfs_mount](./ansible/roles/nfs_mount/README.md)

- [proxmox_init](./ansible/roles/proxmox_init/README.md)

- [qemu_guest_agent](./ansible/roles/qemu_guest_agent/README.md)

## Terraform

To help with automation, a [module](https://developer.hashicorp.com/terraform/language/modules) was created to clone my custom Docker template: [docker_lxc](./terraform/modules/docker_lxc/README.md)

## Shared Variables

Sometimes, I need to share variables between Ansible and Terraform, and since both of them "speak" YAML, I created a [shared_vars](./shared_vars.yaml) file to declare them.

### Unstable notes

- `gpu_devices` in the [`docker_lxc`](./terraform/modules/docker_lxc/vars.tf) is an insane rawdog. If I change CPU's this might break.

- For Windows VM, have an `assets/` folder with the ISO inside it and update it on [`vm_windows.tf`](./terraform/wm_windows.tf)

- VM's are not well tackled yet (will get to it once the *arr stack is deployed)

## Pipeline

- Proxmox bootstrapping (the `proxmox_init` Ansible role)

- Installing OMV

- Preparing NFS share (named `proxmox_data`, mounted using `nfs_mount` Ansible role)

- Deploy LXC Apps

## Creating a Docker template

This script is the most spaghetti IaC I have, but it works, so I won't mess with it.

It will start with:

1. Terraform provisioning the Docker LXC ([lxc_docker_template.tf](./terraform/lxc_docker_template.tf))

2. Ansible configuring it and cleaning up the container ([lxc_template.yml](./ansible/playbooks/lxc_template.yml))

3. Ansible calling back Terraform to fetch the LXC ID and convert it to a template ([lxc_convert_to_template.tf](./terraform/lxc_convert_to_template.tf))

### The Hurdle

Proxmox's API is really strict about enabling `keyctl` and other advanced features on LXC's (that Docker needs) if the user is not `root@pam`, even if you're technically using its API token. So against my better judgement I used direct username/password authentication when performing the templating, but ALL the rest can be done using the API token.

## Mounting folders

This is a big thing for me (given I run apps like Immich inside an LXC and not a VM), I need a reliable way to mout folders (still haven't reached it).

Once again, there are 2 philosophies for this: let Ansible do the work, or prepare it before-hand and Terraform does the rest.

### Ansible-first approach

This was my initial approach, since I wasn't familiar with NFS share organization and didn't have a setup worthy of an ZFS pool and my drives would be destroyed if I attempted it.

The workflow was the following:

- **Terraform:**

    - provisions the LXC, blind to it being one that requires a bind mount or not


- **Ansible:**
    - connects to the pve host itself

    - stops said LXC

    - prepares the NFS share

    - edits the LXC's .conf file, and adds the mountpoint to it

    - it then start it up again, connects to the actual LXC, and deploys the Docker app.

> [!WARNING:]
> this requires you to add a `ignore_changes` block to the LXC, stating that any changes made to mount_point are not to be tracked. Since Terraform did not provision the mount_point, if it sees it there, things will get confusing

### Terraform-first approach

This is my current approach, since my architecture experience has matured.

The workflow is as follows:

- **Ansible:**

    - prepares the NFS shares before-hand (if you're organized, in your initial setup of proxmox even)


- **Terraform:**

    - LXC has a `mount_point` block in it, defining the mounted directory

And you're done!

This might seem easier, but there was a very big hurdle my way: mounting drives via Terraform requires `root@pam` authentication. I had to make a sacrifice of using `root@pam`'s API tokens instead of a custom user (not really a big sacrifice, since my setup is pretty tight when it comes to security everywhere else).

## Joining Terraform and Ansible

This was where most of the issues lived.

There is much debate online on how the "best" way to connect Terraform with Ansible or vice-versa is.

There were times I was led by Reddit comments that seemed convincing enough of some things and I tried to follow them, just to face-plant into a bigger issue after provisioning the resources.

One thing is for certain: **Ansible dynamic inventories are a life-saver**.

With that in mind, I went down a (very small) rabbit hole in search of Proxmox|Ansible dynamic inventories, and by god was it helpful.

Now, we know we don't reallty need to worry about VM IDs since Ansible can access resources by hostname and tag. Unless... You want to mount directories inside the LXC.

There are 2 possible philosophies when it comes to mount binds:

- Bind them on creation: Ideal if you already have the directory outside the LXC.

- Bind them after creation: This was where I encountered myself. If I want to deploy a new service that requires an NFS share; well, time to bind that NFS share to my proxmox host and connect it to the LXC and restart it.

### Representing state

There are some DevOps Engineers who support the idea of _Data-Driven Terraform_, as in, Terraform, despite being a declarative language, will read from a source of truth (like a YAML file) and will use that to provision the resources. This is over-encapsulation in my opinion, but can be a good solution, since Ansible can ingest that same source of truth, meaning both layers are always in agreement.

Here follows a small example:

**architecture.yaml**

```yaml
---
containers:
  nextcloud:
    vmid: 108
    ip_suffix: 108
    nfs_export: "nextcloud"
    mount_target: "/nextcloud_data"
  immich:
    vmid: 110
    ip_suffix: 110
    nfs_export: "immich"
    mount_target: "/mnt/immich_data"
```

**main.tf**

```HCL
locals {
  homelab = yamldecode(file("../homelab.yml"))
}

module "lxc_apps" {
  source   = "./modules/lxc_docker"
  for_each = local.homelab.containers

  container = {
    name      = each.key
    vm_id     = each.value.vmid
    memory    = 2048
    disk_size = 8
  }
}
```

**play.yml**

```yml
- name: Setup NFS mounts for LXC containers
  hosts: proxmox
  become: yes
  vars_files:
    - ../architecture.yaml

  tasks:
    - name: Configure LXC bind mounts
      ansible.builtin.command:
        cmd: "pct set {{ item.value.vmid }} -mp0 /mnt/user/{{ item.value.nfs_export }},mp={{ item.value.mount_target }}"
      loop: "{{ containers | dict2items }}"
```
