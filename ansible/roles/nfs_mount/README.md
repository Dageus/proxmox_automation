# nfs_mount

This role will mount an NFS share to an LXC. It will check if the client has the necessary packages to server NFS shares. Afterwards, it will mount the NFS share on the proxmox host from the NFS server and verify if its accessible.

### Necessary vars

- `nfs_export_directory`: The directory the NFS share is going to be mounted

### Optional vars

- `mount_opts`: The mount options for the NFS share. It defaults the UID and GID of the LXC, from the perspective of the Proxmox host (i.e. UID (inside the LXC) + 100000).
