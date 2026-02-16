resource "null_resource" "convert_to_template" {
  # depends_on = [proxmox_container.docker_template]

  provisioner "remote-exec" {
    inline = [
      "pct stop ${proxmox_virtual_environment_container.docker_template.vm_id}",
      "pct template ${proxmox_virtual_environment_container.docker_template.vm_id}",
    ]

    connection {
      type        = "ssh"
      host        = var.proxmox_host
      user        = "root"
      private_key = file(var.ansible_ssh_key_path)
    }
  }
}
