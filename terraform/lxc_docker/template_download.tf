resource "proxmox_virtual_environment_download_file" "ubuntu_2504_container_img" {
  content_type = "vztmpl"
  datastore_id = "local"
  node_name    = var.proxmox_node
  url          = "https://mirrors.servercentral.com/ubuntu-cloud-images/releases/25.04/release/ubuntu-25.04-server-cloudimg-amd64-root.tar.xz"
}
