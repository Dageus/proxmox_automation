module "filebrowser" {
  source = "./modules/docker_lxc"

  lxc_template_vm_id = var.container_docker_template_id

  container = {
    name      = "filebrowser"
    vm_id     = 101
    memory    = 2048
    disk_size = 8
    tags      = ["ansible", "terraform", "docker"]
    mount_points = [
      {
        volume = "/mnt/hdd1"
        path   = "/data/drive1"
      },
      {
        volume = "/mnt/hdd2"
        path   = "/data/drive2"
      }
    ]
  }
}
