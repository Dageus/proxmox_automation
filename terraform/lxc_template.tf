resource "proxmox_virtual_environment_container" "docker_template" {
  node_name   = var.proxmox_node
  vm_id       = 101
  description = "Debian template with docker pre-installed"
  tags        = ["template", "terraform"]


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
    user_account {
      keys     = [file(var.ansible_ssh_key_path)]
      password = random_password.template_container_password.result
    }
  }

  disk {
    datastore_id = "local"
    size         = 8
  }
}

resource "random_password" "template_container_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}
