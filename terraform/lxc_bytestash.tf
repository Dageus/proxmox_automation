module "byte_stash" {
  count = 0

  source = "./modules/docker_lxc"

  lxc_template_vm_id = var.container_docker_template_id

  container = {
    name      = "bytestash"
    ip_suffix = "204"
    memory    = 512
    disk_size = 6
    tags      = ["terraform", "ansible", "docker"]
  }
}
