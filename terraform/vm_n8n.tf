resource "proxmox_virtual_environment_file" "qemu_agent_install" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "pve"

  source_raw {
    data = <<EOF
#cloud-config
packages:
  - qemu-guest-agent
runcmd:
  - systemctl enable qemu-guest-agent
  - systemctl start qemu-guest-agent
EOF
    file_name = "install-qemu-agent.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "n8n" {
  node_name       = var.proxmox_node
  name            = "n8n"
  stop_on_destroy = true

  tags = ["terraform", "ansible", "cloud-init", "ai"]

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
    dedicated = 2048
    floating  = 2048
  }

  serial_device {
    device = "socket"
  }

  disk {
    datastore_id = "local"
    import_from  = proxmox_download_file.debian_cloud_image.id
    interface    = "scsi0"
    size         = 10
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
        address = "10.10.10.201/24"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.qemu_agent_install.id
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
