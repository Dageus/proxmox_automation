resource "proxmox_virtual_environment_download_file" "debian_cloud_image" {
  node_name    = var.proxmox_node
  datastore_id = "local"
  content_type = "import"
  url          = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
}

resource "proxmox_virtual_environment_download_file" "nixos_image" {
  node_name    = var.proxmox_node
  datastore_id = "local"
  content_type = "iso"
  url          = "https://releases.nixos.org/nixos/24.05/nixos-24.05.7376.b134951a4c9f/nixos-minimal-24.05.7376.b134951a4c9f-x86_64-linux.iso"
  file_name    = "nixos.iso"
}

resource "proxmox_virtual_environment_download_file" "windows_image" {
  node_name    = var.proxmox_node
  datastore_id = "local"
  content_type = "iso"
  # TODO:
  url          = ""
  file_name    = "windows.iso"
}

resource "proxmox_virtual_environment_file" "virtio_drivers" {
  node_name    = var.proxmox_node
  datastore_id = "local"
  content_type = "iso"

  source_file {
    path = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso"
    file_name = "virtio-win.iso"
  }
}
