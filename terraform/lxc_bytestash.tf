module "byte_stash" {
  source = "./modules/docker_lxc"

  lxc_template_vm_id = var.container_docker_template_id

  container = {
    name      = "bytestash"
    ip_suffix = "213"
    memory    = 512
    disk_size = 8
    tags      = ["terraform", "ansible", "docker"]
  }
}
