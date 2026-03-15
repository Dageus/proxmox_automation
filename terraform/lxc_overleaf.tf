module "overleaf" {
  source = "./modules/docker_lxc"

  lxc_template_vm_id = var.container_docker_template_id

  container = {
    name      = "overleaf"
    vm_id     = 118
    memory    = 2048
    disk_size = 8
    tags      = ["terraform", "finance", "docker"]
  }
}
