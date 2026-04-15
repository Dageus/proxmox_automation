resource "proxmox_virtual_environment_vm" "openmediavault" {
  # NOTE: hack to disable this resource
  count = 0

  node_name       = "pve"
  name            = "openmediavault"
  stop_on_destroy = true

  tags = ["nas", "terraform_provisioned"]

  agent {
    enabled = true
    timeout = "0s"
  }

  startup {
    order      = "0"
    up_delay   = "60"
    down_delay = "60"
  }

  # CPU / Memory
  cpu {
    cores   = 2
    sockets = 1
    type    = "host"
    # my host's CPU doesn't support AES
    # NOTE: now it does :)
    # flags   = ["-aes"]
  }

  memory {
    dedicated = 2048
    floating  = 2048
  }

  serial_device {
    device = "socket"
  }

  # Main system disk from Debian cloud image
  disk {
    datastore_id = "local"
    import_from  = proxmox_download_file.debian_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
  }

  # External SSD passthrough
  disk {
    datastore_id      = ""
    interface         = "sata0"
    path_in_datastore = "/dev/disk/by-id/${var.external_ssd_disk_name}"
    file_format       = "raw"
    ssd               = true
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


  # Cloud-init / SSH / networking
  initialization {
    datastore_id = "local"

    user_account {
      username = "root"
      keys     = [file(var.ssh_public_key_path)]
      password = "root"

    }

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    ip_config {
      ipv4 {
        address = "10.10.10.200/24"
      }
    }
  }

  # Boot order
  boot_order = ["virtio0"]
}
