module "npm" {
  source = "./modules/docker_lxc"

  lxc_template_vm_id = var.container_docker_template_id

  container = {
    name      = "npm"
    vm_id     = 118
    memory    = 2048
    disk_size = 8
    tags      = ["terraform", "docker"]
  }
}
