resource "proxmox_virtual_environment_container" "docker_template" {
  node_name   = var.proxmox_node
  vm_id       = var.container_docker_template_id
  description = "Debian template with docker pre-installed"
  tags        = ["template", "terraform", "ansible"]


  unprivileged = true

  operating_system {
    template_file_id = proxmox_virtual_environment_download_file.debian-12-standard.id
    type             = "debian"
  }

  features {
    nesting = true
    keyctl  = true
  }

  initialization {
    hostname = var.container_docker_template_name

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      keys     = [file(var.ssh_public_key_path)]
      password = random_password.template_container_password.result
    }
  }

  network_interface {
    name = "veth0"
  }

  disk {
    datastore_id = "local"
    size         = 6
  }

  lifecycle {
    ignore_changes = [
      template,
      started
    ]
  }
}

resource "random_password" "template_container_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}
