resource "proxmox_virtual_environment_vm" "windows_vm" {
  node_name = var.proxmox_node
  name      = "windows-sandbox"

  tags = ["windows", "terraform"]

  startup {
    order      = "2"
    up_delay   = "60"
    down_delay = "60"
  }

  cpu {
    cores   = 4
    sockets = 1
    type    = "host"
  }

  memory {
    dedicated = 4096
    floating  = 1024
  }

  disk {
    datastore_id = "local"
    file_format  = "raw"
    interface    = "virtio"
    size         = 64
  }

  serial_device {
    device = "socket"
  }

  cdrom {
    enabled   = true
    file_id   = "local:iso/Windows11.iso"
    interface = "ide0"
  }

  # Attach the VirtIO ISO
  cdrom {
    enabled   = true
    file_id   = proxmox_virtual_environment_file.virtio_drivers.id
    interface = "ide1"
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }
}
