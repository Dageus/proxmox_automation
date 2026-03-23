module "nginx" {
  source = "./modules/docker_lxc"

  lxc_template_vm_id = var.container_docker_template_id

  container = {
    name      = "nginx"
    memory    = 512
    disk_size = 6
    tags      = ["terraform", "ansible", "docker", "proxy"]
  }
}
