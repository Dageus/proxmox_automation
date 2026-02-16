module "focalboard" {
  source = "./lxc_docker"

  container = {
    name      = "focalboard",
    vm_id     = 118
    memory    = 256
    disk_size = 8
  }
}
