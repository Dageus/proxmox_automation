module "portainer" {
  source = "./modules/docker_lxc"

  lxc_template_vm_id = var.container_docker_template_id

  count = 0

  container = {
    name      = "portainer"
    ip_suffix = "216"
    memory    = 1024
    disk_size = 6
    tags      = ["terraform", "ansible", "docker", "mgmt"]
  }
}
