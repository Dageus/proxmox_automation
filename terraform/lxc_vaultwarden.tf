module "vaultwarden" {
  source = "./modules/docker_lxc"

  lxc_template_vm_id = var.container_docker_template_id

  container = {
    name      = "vaultwarden"
    ip_suffix = "219"
    memory    = 1024
    disk_size = 6
    tags      = ["terraform", "ansible", "docker"]
  }
}
