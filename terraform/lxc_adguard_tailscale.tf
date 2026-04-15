module "adguard" {
  source = "./modules/docker_lxc"

  lxc_template_vm_id = var.container_docker_template_id

  container = {
    name      = "adguard"
    ip_suffix = "211"
    memory    = 1024
    disk_size = 6
    tags      = ["terraform", "ansible", "docker", "vpn"]
  }
}
