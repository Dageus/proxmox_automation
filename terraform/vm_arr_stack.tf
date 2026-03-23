resource "proxmox_virtual_environment_vm" "arr_stack" {
  node_name       = var.proxmox
  name            = "arr_stack"
  stop_on_destroy = true

  tags = ["terraform", "ansible", "cloud-init", "external_disk", "gpu"]

  agent {
    enabled = true
    timeout = "0s"
  }

  startup {
    order      = "2"
    up_delay   = "60"
    down_delay = "60"
  }

  # CPU / Memory
  cpu {
    cores   = 2
    sockets = 1
    type    = "host"
  }

  memory {
    dedicated = 1024
    floating  = 1024
  }

  serial_device {
    device = "socket"
  }

  # Main system disk from Debian cloud image
  disk {
    datastore_id = "local"
    import_from  = proxmox_virtual_environment_download_file.debian_cloud_image.id
    interface    = "scsi0"
    size         = 20
  }

  # Network Interface for LAN
  network_device {
    model  = "virtio"
    bridge = "vmbr0"
  }

  # Network Interface for Proxmox Internal Network
  network_device {
    model  = "virtio"
    bridge = "vmbr1"
  }

  # Boot order
  boot_order = ["virtio0"]
}
