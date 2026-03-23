module "overleaf" {
  source = "./modules/docker_lxc"

  lxc_template_vm_id = var.container_docker_template_id

  container = {
    name      = "overleaf"
    memory    = 2048
    disk_size = 20
    tags      = ["terraform", "ansible", "docker"]
  }
}
