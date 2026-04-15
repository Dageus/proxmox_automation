module "paperless_ngx" {
  source = "./modules/docker_lxc"

  lxc_template_vm_id = var.container_docker_template_id

  container = {
    name      = "paperless-ngx"
    ip_suffix = "222"
    memory    = 2048
    disk_size = 20
    tags      = ["terraform", "ansible", "docker", "media"]
    mount_points = [
      {
        volume = "/mnt/ssd/paperless"
        path   = "/mnt/paperless_ngx_data"
      },
    ]
  }
}
