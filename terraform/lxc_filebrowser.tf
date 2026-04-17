module "filebrowser" {
  source = "./modules/docker_lxc"

  # NOTE: disabling this resource
  count = 0

  lxc_template_vm_id = var.container_docker_template_id

  container = {
    name      = "filebrowser"
    memory    = 1024
    ip_suffix = "207"
    disk_size = 6
    tags      = ["terraform", "ansible", "docker", "media", "external_disk"]
  }
}
