module "nextcloud" {
  source = "./modules/docker_lxc"

  lxc_template_vm_id = var.container_docker_template_id

  container = {
    name      = "nextcloud",
    ip_suffix = "212"
    memory    = 2048
    disk_size = 6
    tags      = ["terraform", "ansible", "docker", "media", "external_disk"]
    mount_points = [
      {
        volume = "/mnt/ssd/nextcloud"
        path   = "/nextcloud_data"
      },
    ]
  }
}
