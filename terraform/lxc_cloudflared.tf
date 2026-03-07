module "cloudflared" {
  source = "./modules/docker_lxc"

  ssh_public_key_path = var.ssh_public_key_path
  lxc_template_vm_id = var.container_docker_template_id

  container = {
    name      = "cloudflared"
    vm_id     = 101
    memory    = 2048
    disk_size = 8
    tags      = ["terraform", "cloudflare", "docker"]
    password  = "cloudflared"
  }
}
