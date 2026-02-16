resource "proxmox_virtual_environment_vm" "nixos" {
  node_name       = "pve"
  name            = "nix-playground"
  vm_id           = 202
  stop_on_destroy = true

  tags = ["playground", "terraform_provisioned"]

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
    flags   = ["-aes"] # my host's CPU doesn't support AES
  }

  memory {
    dedicated = 1024
    floating  = 1024
  }

  serial_device {
    device = "socket"
  }

  # Main system disk from Debian cloud image
  disk {
    datastore_id = "local"
    import_from  = proxmox_virtual_environment_download_file.nixos_image.id
    interface    = "scsi0"
    size         = 20
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
