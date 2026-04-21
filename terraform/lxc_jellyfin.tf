module "jellyfin" {
  source = "./modules/docker_lxc"

  lxc_template_vm_id = var.container_docker_template_id

  gpu_passthrough = true

  container = {
    name      = "jellyfin",
    ip_suffix = "211"
    memory    = 2048
    disk_size = 30
    tags      = ["terraform", "ansible", "docker", "media", "external_disk"]
    mount_points = [
      {
        volume = "/mnt/ssd/arr/media"
        path   = "/media"
      }
    ]
  }
}
