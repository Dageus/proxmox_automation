resource "proxmox_virtual_environment_container" "vikunja" {
  node_name   = var.proxmox_node
  vm_id       = 119
  description = "LXC for Vikunja"
  tags        = ["terraform"]

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
    hostname = ""
    user_account {
      keys     = [file(var.ansible_ssh_key_path)]
      password = random_password.vikunja_password.result
    }

    ip_config {
      ipv4 {
        address = "192.168.1.219/24"
        gateway = "192.168.1.1"
      }
    }

    ip_config {
      ipv4 {
        address = "10.150.0.119/16"
        gateway = "10.150.0.1"
      }
    }
  }

  network_interface {
    name   = "veth0"
    bridge = "vmbr0"
  }

  network_interface {
    name   = "veth1"
    bridge = "vmbr1"
  }

  features {
    nesting = true # required for Docker in LXC
    keyctl  = true
  }
}

resource "random_password" "vikunja_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}
