module "glance" {
  source = "./modules/docker_lxc"

  lxc_template_vm_id = var.container_docker_template_id

  container = {
    name      = "glance"
    ip_suffix = "209"
    memory    = 512
    disk_size = 6
    tags      = ["terraform", "ansible", "docker"]
  }
}
