module "actual_budget" {
  source = "./modules/lxc_docker"

  ssh_public_key_path = var.ssh_public_key_path
  lxc_template_vm_id = var.container_docker_template_id

  container = {
    name      = "actual-budget"
    vm_id     = 118
    memory    = 2048
    disk_size = 8
    tags      = ["terraform", "finance", "docker"]
    password  = "actualbudget"
  }
}

resource "null_resource" "run_ansible_actual_budget" {
  depends_on = [module.actual_budget]

  triggers = {
    vm_id = "118"
  }

  provisioner "local-exec" {
    command = <<-EOT
      sleep 5

      ansible-playbook -i infrastructure/ansible/inventory.ini \
        infrastructure/ansible/deploy_actual_budget.yml \
        --vault-password-file .vault_pass.txt \
        -e "target_host=192.168.1.218"
    EOT
  }
}
