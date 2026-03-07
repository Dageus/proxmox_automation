# lxc_mount

This role will add a mountpoint to an LXC container. This is helpful if you're going to run a data-intensive application that may need access to an external directory (in my case, it access an external NFS share on the proxmox host itself).

It has safe behaviour such as stopping the LXC if it's running, and starts the LXC back after the bind mount has been done. It also checks if mount has been succesful (by checking the directory ownership).

### Necessary vars

- `lxc_id`: The LXC VM ID of the container you want to mount the given directory

- `lxc_mount_target`: The path of the mounted directory INSIDE the LXC

- `nfs_export_directory`: The path of the NFS share/directory in the Proxmox host

### Optional vars

- `mp_index`: The mountpoint index of the directory (if you're only mounting one directory you don't have to worry about this)
