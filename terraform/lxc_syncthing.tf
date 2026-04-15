module "syncthing" {
  source = "./modules/docker_lxc"

  lxc_template_vm_id = var.container_docker_template_id

  container = {
    name      = "syncthing"
    ip_suffix = "224"
    memory    = 512
    disk_size = 6
    tags      = ["terraform", "ansible", "docker", "media", "external_disk"]
    mount_points = [
      {
        volume = "/mnt/ssd/syncthing"
        path   = "/mnt/syncthing_data"
      },
    ]
  }
}
