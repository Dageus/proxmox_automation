module "immich" {
  source = "./modules/docker_lxc"

  lxc_template_vm_id = var.container_docker_template_id

  container = {
    name      = "immich",
    vm_id     = 110
    memory    = 2048
    disk_size = 8
    tags      = ["terraform", "media", "docker"]
  }
}

# {
#       "mode": "managed",
#       "type": "proxmox_virtual_environment_container",
#       "name": "temp_immich",
#       "provider": "provider[\"registry.terraform.io/bpg/proxmox\"]",
#       "instances": [
#         {
#           "schema_version": 0,
#           "attributes": {
#             "clone": [],
#             "console": [
#               {
#                 "enabled": true,
#                 "tty_count": 2,
#                 "type": "tty"
#               }
#             ],
#             "cpu": [
#               {
#                 "architecture": "amd64",
#                 "cores": 2,
#                 "units": 1024
#               }
#             ],
#             "description": "",
#             "device_passthrough": [
#               {
#                 "deny_write": false,
#                 "gid": 104,
#                 "mode": "0660",
#                 "path": "/dev/dri/renderD128",
#                 "uid": 0
#               }
#             ],
#             "disk": [
#               {
#                 "acl": false,
#                 "datastore_id": "local",
#                 "mount_options": [],
#                 "quota": false,
#                 "replicate": false,
#                 "size": 16
#               }
#             ],
#             "features": [],
#             "hook_script_file_id": null,
#             "id": "110",
#             "initialization": [
#               {
#                 "dns": [],
#                 "hostname": "immich",
#                 "ip_config": [
#                   {
#                     "ipv4": [
#                       {
#                         "address": "192.168.1.210/24",
#                         "gateway": "192.168.1.1"
#                       }
#                     ],
#                     "ipv6": []
#                   },
#                   {
#                     "ipv4": [
#                       {
#                         "address": "10.150.0.110/16",
#                         "gateway": "10.150.0.1"
#                       }
#                     ],
#                     "ipv6": []
#                   }
#                 ],
#                 "user_account": []
#               }
#             ],
#             "ipv4": {
#               "br-7c747a6a1775": "172.18.0.1",
#               "docker0": "172.17.0.1",
#               "eth0": "192.168.1.210",
#               "eth1": "10.150.0.110"
#             },
#             "ipv6": {
#               "br-7c747a6a1775": "fe80::42:b2ff:fe54:d5be",
#               "eth0": "fe80::be24:11ff:fe54:164f",
#               "eth1": "fe80::be24:11ff:fe10:8889",
#               "veth0932bf1": "fe80::70e0:a3ff:fea7:1a4a",
#               "veth16b572b": "fe80::f40b:f1ff:fed9:f614",
#               "vethb370fd9": "fe80::e6:1dff:fe40:6f75",
#               "vethea5c639": "fe80::c46c:24ff:fe7a:810"
#             },
#             "memory": [
#               {
#                 "dedicated": 2048,
#                 "swap": 512
#               }
#             ],
#             "mount_point": [
#               {
#                 "acl": false,
#                 "backup": false,
#                 "mount_options": [],
#                 "path": "/mnt/immich_data",
#                 "quota": false,
#                 "read_only": false,
#                 "replicate": true,
#                 "shared": false,
#                 "size": "",
#                 "volume": "/mnt/nas/immich"
#               }
#             ],
#             "network_interface": [
#               {
#                 "bridge": "vmbr0",
#                 "enabled": true,
#                 "firewall": true,
#                 "mac_address": "BC:24:11:54:16:4F",
#                 "mtu": 0,
#                 "name": "eth0",
#                 "rate_limit": 0,
#                 "vlan_id": 0
#               },
#               {
#                 "bridge": "vmbr1",
#                 "enabled": true,
#                 "firewall": true,
#                 "mac_address": "BC:24:11:10:88:89",
#                 "mtu": 0,
#                 "name": "eth1",
#                 "rate_limit": 0,
#                 "vlan_id": 0
#               }
#             ],
#             "node_name": "pve",
#             "operating_system": [
#               {
#                 "template_file_id": "",
#                 "type": "debian"
#               }
#             ],
#             "pool_id": null,
#             "protection": false,
#             "start_on_boot": null,
#             "started": true,
#             "startup": [],
#             "tags": [
#               "docker"
#             ],
#             "template": false,
#             "timeout_clone": null,
#             "timeout_create": null,
#             "timeout_delete": null,
#             "timeout_start": null,
#             "timeout_update": null,
#             "unprivileged": true,
#             "vm_id": null
#           },
#           "sensitive_attributes": [],
#           "identity_schema_version": 0,
#           "private": "eyJzY2hlbWFfdmVyc2lvbiI6IjAifQ=="
#         }
#       ]
#     },
