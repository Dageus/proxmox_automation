module "authentik" {
  source = "./modules/docker_lxc"

  lxc_template_vm_id = var.container_docker_template_id

  container = {
    name      = "authentik"
    ip_suffix = "222"
    memory    = 1024
    disk_size = 6
    tags      = ["terraform", "ansible", "docker", "authentication"]
  }
}

# locals {
#   host_files = fileset("../ansible/inventories/host_vars", "*.yml")
#
#   decoded_hosts = {
#     for f in local.host_files : f => yamldecode(file("../ansible/inventories/host_vars/${f}"))
#   }
#
#   all_services = flatten([
#     for host_file, data in local.decoded_hosts : try(data.services, [])
#   ])
#
#   proxy_apps = {
#     for svc in local.all_services :
#     svc.subdomain => svc
#     if try(svc.auth_type, "proxy") == "proxy" && try(svc.subdomain, "") != "status"
#   }
#
#   oidc_apps = {
#     for svc in local.all_services :
#     svc.subdomain => svc
#     if try(svc.auth_type, "proxy") == "oidc"
#   }
# }
#
# data "authentik_flow" "default-authorization-flow" {
#   slug = "default-provider-authorization-implicit-consent"
# }
#
# resource "authentik_provider_proxy" "dynamic_providers" {
#   for_each      = local.proxy_apps
#   name          = "${each.key}-provider"
#   # ... (proxy specific settings)
# }
#
# resource "authentik_provider_oauth2" "dynamic_oidc_providers" {
#   for_each      = local.oidc_apps
#   name          = "${each.key}-oidc-provider"
#   client_id     = each.key
#   # ... (OIDC specific settings)
# }
#
# resource "authentik_application" "all_apps" {
#   for_each = merge(local.proxy_apps, local.oidc_apps)
#
#   name = try(each.value.title, title(each.key))
#   slug = each.key
#
#   protocol_provider = contains(keys(local.proxy_apps), each.key) ? authentik_provider_proxy.dynamic_providers[each.key].id : authentik_provider_oauth2.dynamic_oidc_providers[each.key].id
# }
