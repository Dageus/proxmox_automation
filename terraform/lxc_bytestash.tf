module "byte_stash" {
  source = "./modules/docker_lxc"

  lxc_template_vm_id = var.container_docker_template_id

  container = {
    name      = "bytestash"
    vm_id     = 120
    memory    = 2048
    disk_size = 8
    tags      = ["terraform", "finance", "docker"]
  }
}
