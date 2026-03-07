# proxmox_init

This role is what kickstarts my proxmox server on a fresh install. It handles 5 main things:

- [hardware](./tasks/hardware.yml) tweaks: installing necessary packages to monitor CPU cores and setting the necessary governor for the CPU to not be overclocking all the time.

- [network](./tasks/network.yml) tweaks: adding the Internal Proxmox Network Bridge that allows Proxmox containers and VMs to talk to each other without traffic in the LAN.

- [repository](./tasks/repository.yml) tweaks: removing the enterprise repository and adding the no-subscription repository and updating the system and sources.

- [security](./tasks/security.yml) tweaks: Creating a Role (if specified) along with API tokens and removing Password Authentication from SSH (after copying a fresh SSH key into the known keys).

- [storage](./tasks/storage.yml) tweaks: Decreasing swappiness, disabling HA, enabling [fstrim](https://man7.org/linux/man-pages/man8/fstrim.8.html), removing `local-lvm` (if specified).

- [extra](./tasks/tweaks.yml) tweaks: Disabling the Subscription Nag.

I know most of this is done by the [Proxmox Community Post-Install script](https://community-scripts.github.io/ProxmoxVE/scripts?id=post-pve-install), but I wanted to learn how to do this and automate it if possible (why not).

### Necessary vars

N/A

### Optional vars

- `pve_cpu_governor_intel`: Governor for the Intel processor

- `pve_cpu_governor_amd`: Governor for the AMD processor

- `pve_swappiness`: Value from 0 (off) to 100 (intensive) swappiness from the kernel (How much memory is offloaded from RAM to swap)

- `pve_remove_local_lvm`: Specifies if `local-lvm` is to be removed

- `pve_enable_fstrim`: Specifies if `fstrim` is to be enabled

- `pve_manage_repos`: Specifies if the enterprise repository is to be removed

- `pve_remove_subscription_nag`: If the subscription nag is to be removed

- `pve_api_user`: The name of the API user to be created

- `pve_api_password`: The password of the API user to be created

- `pve_api_token`: The name of the API token to be created

- `pve_create_api_tokens`: If API tokens are to be created

- `pve_create_root_api_token`: If an API token for `root@pam` is to be created
