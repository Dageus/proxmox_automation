# Blank vars for use by terraform.tfvars
variable "proxmox_api_token" {
}
variable "proxmox_user_password" {
}
variable "proxmox_user_name" {
}
variable "proxmox_auth_ticket" {
}
variable "proxmox_csrf_token" {
}
# default variables
variable "proxmox_host" {
  type        = string
  description = "Proxmox host endpoint or IP"
  default     = "https://192.168.1.75:8006/"
}
variable "proxmox_node" {
  type        = string
  description = "Name of the Proxmox Node where the resources will be deployed"
  default     = "pve"
}
variable "container_docker_template_name" {
  type        = string
  description = "LXC name of the Docker Template Container"
  default     = "docker-template"
}
variable "container_os_template_name" {
  type        = string
  description = "OS template to be used when creating LXC"
  default     = "debian-12-standard_12.7-1_amd64.tar.zst"
}
variable "ansible_ssh_key_path" {
  type        = string
  description = "Location of the Ansible ssh key in the filesystem"
  default     = "~/.ssh/ansible_ssh.pub"
}
variable "external_ssd_disk_name" {
  type        = string
  description = "Name of the external SSD when ls'ing /dev/disk/by-id/"
  default     = "usb-WD_Blue_SN5000_1TB_012345678923-0:0"
}
