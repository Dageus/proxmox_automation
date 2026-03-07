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

variable "ssh_public_key_path" {
  type        = string
  description = "Public SSH Key of the Ansible user"
}

variable "gpu_passthrough" {
  type        = bool
  description = "Whether to mount Intel GPU render devices into the container"
  default     = false
}

variable "gpu_devices" {
  type        = list(string)
  default     = ["/dev/dri/renderD128", "/dev/dri/card0"]
  description = "List of GPU device paths to mount if passthrough is enabled"
}

variable "container" {
  type = object({
    name      = string
    vm_id     = number
    memory    = number
    disk_size = number
    tags      = list(string)
    password  = optional(string)
  })
}
