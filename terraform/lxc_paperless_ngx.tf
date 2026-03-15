module "paperless_ngx" {
  source = "./modules/docker_lxc"

  lxc_template_vm_id = var.container_docker_template_id

  container = {
    name      = "paperless_ngx"
    vm_id     = 121
    memory    = 2048
    disk_size = 8
    tags      = ["terraform", "media", "docker"]
  }
}
