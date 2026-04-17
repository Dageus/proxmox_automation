module "arr_stack" {
  source = "./modules/docker_lxc"

  lxc_template_vm_id = var.container_docker_template_id

  enable_tun = true

  container = {
    name      = "arr-stack",
    ip_suffix = "202"
    memory    = 2048
    disk_size = 8
    tags      = ["terraform", "ansible", "docker", "media", "external_disk"]
    mount_points = [
      {
        # The path on the Proxmox Host
        volume = "/mnt/ssd/arr/"
        # Where it appears INSIDE the LXC
        path   = "/data"
      }
    ]
  }
}
