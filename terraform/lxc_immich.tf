module "immich" {
  source = "./modules/docker_lxc"

  lxc_template_vm_id = var.container_docker_template_id

  gpu_passthrough = true

  container = {
    name      = "immich",
    ip_suffix = "210"
    memory    = 2048
    disk_size = 15
    tags      = ["terraform", "ansible", "docker", "media", "external_disk"]
    mount_points = [
      {
        # The path on the Proxmox Host
        volume = "/mnt/ssd/immich"
        # Where it appears INSIDE the LXC
        path   = "/immich_data"
      }
    ]
  }
}
