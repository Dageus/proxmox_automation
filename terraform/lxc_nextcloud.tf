module "nextcloud" {
  source = "./modules/docker_lxc"

  ssh_public_key_path = var.ssh_public_key_path
  lxc_template_vm_id = var.container_docker_template_id

  container = {
    name      = "nextcloud",
    vm_id     = 108
    memory    = 2048
    disk_size = 8
    tags      = ["terraform", "media", "docker"]
    password  = "nextcloud"
  }
}
