resource "proxmox_virtual_environment_container" "nextcloud" {
  node_name   = var.proxmox_node
  vm_id       = 108
  description = "LXC for Nextcloud"
  tags        = ["terraform", "file_hosting", "nas"]

  started    = true
  protection = false

  // clone from the docker template LXC
  clone {
    datastore_id = "local"
    node_name    = var.proxmox_node
    vm_id        = proxmox_virtual_environment_container.docker_template.vm_id
  }

  memory {
    dedicated = 2048
    swap      = 2048
  }

  initialization {
    hostname = "root"
    user_account {
      keys     = [file(var.ansible_ssh_key_path)]
      password = random_password.nextcloud_password.result
    }
    ip_config {
      ipv4 {
        address = "192.168.1.208/24"
        gateway = "192.168.1.1"
      }
    }

    ip_config {
      ipv4 {
        address = "10.150.0.108/16"
        gateway = "10.150.0.1"
      }
    }
  }

  network_interface {
    bridge = "vmbr0"
    name   = "eth0"
  }

  network_interface {
    bridge = "vmbr1"
    name   = "eth1"
  }

  features {
    nesting = true # required for Docker in LXC
    keyctl  = true
  }
}

resource "random_password" "nextcloud_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}
