module "romm" {
  source = "./modules/docker_lxc"

  lxc_template_vm_id = var.container_docker_template_id

  container = {
    name      = "romm"
    ip_suffix = "217"
    memory    = 1024
    disk_size = 6
    tags      = ["terraform", "ansible", "docker", "games", "external_disk"]
    mount_points = [
      {
        volume = "/mnt/sdd/romm"
        path   = "/mnt/romm_data"
      }
    ]
  }
}
