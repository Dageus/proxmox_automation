resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "pve"

  source_raw {
    data = <<-EOF
    #cloud-config
    hostname: n8n
    timezone: Europe/Lisbon
    users:
      - default
      - name: debian
        groups:
          - sudo
        shell: /bin/bash
        ssh_authorized_keys:
          - ${trimspace(file(var.ssh_public_key_path))}
        sudo: ALL=(ALL) NOPASSWD:ALL
    package_update: true
    packages:
      - qemu-guest-agent
      - net-tools
      - curl
    runcmd:
      - systemctl enable qemu-guest-agent
      - systemctl start qemu-guest-agent
      - echo "done" > /tmp/cloud-config.done
    EOF

    file_name = "user-data-cloud-config.yaml"
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
        address = "192.168.1.221/24"
        gateway = "192.168.1.1"
      }
    }

    ip_config {
      ipv4 {
        address = "10.10.10.221/16"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
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
