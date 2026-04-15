terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.102.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_host

  insecure = true

  # API Token
  # api_token = var.proxmox_api_token

  # Auth Ticket
  # auth_ticket = var.proxmox_auth_ticket
  # csrf_token  = var.proxmox_csrf_token

  # Username/Password
  username = var.proxmox_user_name
  password = var.proxmox_user_password

  ssh {
    agent = true
    username = "root"
    private_key = file("../.ssh/ansible")
  }
}
