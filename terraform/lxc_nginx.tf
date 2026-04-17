module "nginx" {
  count = 0

  source = "./modules/docker_lxc"

  lxc_template_vm_id = var.container_docker_template_id

  container = {
    name      = "nginx"
    ip_suffix = "213"
    memory    = 512
    disk_size = 6
    tags      = ["terraform", "ansible", "docker", "proxy"]
  }
}
