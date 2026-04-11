locals {
  shared = yamldecode(file("${path.module}/../shared_vars.yaml"))
  ssd_datastore = [for dev in local.shared.storage_devices : dev.datastore_name if dev.name == "app_ssd"][0]
}

resource "proxmox_virtual_environment_vm" "arr_stack" {
  node_name       = var.proxmox
  name            = "arr_stack"
  stop_on_destroy = true

  tags = ["terraform", "ansible", "cloud-init", "external_disk"]

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
    dedicated = 4096
    floating  = 4096
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

  disk {
    datastore_id = local.ssd_datastore
    interface    = "scsi1"
    size         = 500
    file_format  = "qcow2"
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
        address = "10.150.0.201/24"
        gateway = "10.150.0.1"
      }
    }
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
  boot_order = ["scsi0"]
}
