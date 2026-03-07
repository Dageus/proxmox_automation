resource "proxmox_virtual_environment_container" "container" {
  node_name   = var.proxmox_node
  vm_id       = var.container.vm_id
  description = "LXC for ${var.container.name}"
  tags        = var.container.tags

  start_on_boot = true
  protection    = false

  clone {
    datastore_id = "local"
    node_name    = var.proxmox_clone_node
    vm_id        = var.lxc_template_vm_id
  }

  disk {
    datastore_id = "local"
    size         = var.container.disk_size
  }

  memory {
    dedicated = var.container.memory
    swap      = 2048
  }

  initialization {
    hostname = var.container.name

    user_account {
      keys = [file(var.ansible_ssh_key_path)]
      password = var.container.password
    }

    ip_config {
      ipv4 {
        address = "192.168.1.2${substr(var.container.vm_id, -2, 2)}/24"
        gateway = "192.168.1.1"
      }
    }

    ip_config {
      ipv4 {
        address = "10.150.0.${var.container.vm_id}/16"
        # gateway = "10.150.0.1"
      }
    }
  }

  network_interface {
    bridge = "vmbr0"
    name   = "veth0"
  }
  network_interface {
    bridge = "vmbr1"
    name   = "veth1"
  }

  features {
    nesting = true
    keyctl  = true
  }

  # GPU passthrough
  dynamic "device_passthrough" {
    for_each = var.gpu_passthrough ? toset(var.gpu_devices) : []
    content {
      path = device_passthrough.value
    }
  }
}
