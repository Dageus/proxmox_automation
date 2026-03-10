module "syncthing" {
  source = "./modules/lxc_docker"

  ssh_public_key_path = var.ssh_public_key_path
  lxc_template_vm_id = var.container_docker_template_id

  container = {
    name      = "syncthing"
    vm_id     = 118
    memory    = 2048
    disk_size = 8
    tags      = ["terraform", "docker"]
    password  = "syncthing"
  }
}
