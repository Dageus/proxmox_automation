variable "proxmox_node" {
  type        = string
  description = "Name of the proxmox node where we'll connect to"
  default     = "pve"
}

variable "lxc_template_vm_id" {
  type        = number
  description = "VM ID of the LXC template"
}

variable "proxmox_clone_node" {
  type        = string
  description = "Name of the proxmox node where the LXC template is"
  default     = "pve"
}

variable "gpu_passthrough" {
  type        = bool
  description = "Whether to mount Intel GPU render devices into the container"
  default     = false
}

variable "gpu_devices" {
  type        = list(string)
  default     = ["/dev/dri/renderD128", "/dev/dri/card1"]
  description = "List of GPU device paths to mount if passthrough is enabled"
}

variable "enable_tun" {
  type        = bool
  description = "Enable TUN device for VPNs (WireGuard, Gluetun, Tailscale)"
  default     = false
}

variable "container" {
  type = object({
    name      = string
    vm_id     = optional(number)
    ip_suffix = string
    memory    = number
    disk_size = number
    tags      = list(string)
    mount_points = optional(list(object({
      volume = string
      path   = string
    })), [])
  })
}
