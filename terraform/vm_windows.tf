resource "proxmox_download_file" "virtio_drivers" {
  count = 0

  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve"
  url          = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso"
  file_name = "virtio-win.iso"
}

resource "proxmox_virtual_environment_file" "windows_11_iso" {
  count = 0

  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve"
  source_file  {
    path = "${path.module}/assets/Win11_English_x64.iso"
  }
}

resource "proxmox_virtual_environment_vm" "windows_vm" {
  # NOTE: hack to disable this resource
  count = 0

  node_name = var.proxmox_node
  name      = "windows-sandbox"

  tags = ["windows", "terraform"]

  machine = "q35"
  bios    = "ovmf"

  efi_disk {
    datastore_id = "local"
    type         = "4m"
  }

  tpm_state {
    datastore_id = "local"
    version      = "v2.0"
  }

  startup {
    order      = "2"
    up_delay   = "60"
    down_delay = "60"
  }

  cpu {
    cores   = 4
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

  cdrom {
    enabled   = true
    file_id   = proxmox_virtual_environment_file.windows_11_iso[0].id
    interface = "ide0"
  }

  disk {
    datastore_id = "local"
    file_id      = proxmox_download_file.virtio_drivers[0].id
    interface    = "ide2"
  }

  disk {
    datastore_id = "local"
    interface    = "scsi0"
    size         = 64
    file_format  = "raw"
    discard      = "on"
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }
}
