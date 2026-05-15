module "networks" {
  source   = "./modules/network"
  for_each = var.networks

  network_name        = each.value.name
  cidr                = each.value.cidr
  gateway_ip          = each.value.gateway_ip
  external_network_id = each.value.external_net
  network_id          = each.value.id
}

module "security_group" {
  source = "./modules/security_group"

  security_groups = var.security_groups
}

locals {
  network_ids = { for k, v in module.networks : k => v.network_id }
}

module "ports" {
  source = "./modules/ports"

  ports = {
    for k, v in var.ports : k => {
      id         = v.id
      network_id = v.network_name != null ? local.network_ids[v.network_name] : v.network_id
      ip         = v.ip
      security_group_ids = concat(
        [for name in v.security_group_names : module.security_group.security_group_ids[name]],
        v.security_group_ids,
      )
    }
  }
}

locals {
  port_ids = module.ports.port_ids

  auto_volumes = {
    for k, v in var.vms : "${k}-vol" => {
      size       = v.volume_size
      image_name = v.image_name
    } if v.volume_size != null
  }

  all_volumes = merge(var.volumes, local.auto_volumes)

  vms_resolved = {
    for vm_name, vm in var.vms : vm_name => merge(vm, {
      ports = [
        for p in vm.ports : {
          network_id = (
            p.network_id != null ? p.network_id :
            p.network_name != null ? local.network_ids[p.network_name] :
            null
          )
          ip      = p.ip
          port_id = (
            p.port_id != null ? p.port_id :
            p.port_name != null ? local.port_ids[p.port_name] :
            null
          )
          security_group_ids = concat(
            [
              for name in (p.security_group_names != null ? p.security_group_names : vm.security_group_names) :
              module.security_group.security_group_ids[name]
            ],
            vm.security_group_ids,
            p.security_group_ids,
          )
        }
      ]
    })
  }
}

module "volume" {
  source = "./modules/volume"

  volumes = local.all_volumes
}

module "vm" {
  source = "./modules/vm"

  vms = {
    for k, v in local.vms_resolved : k => {
      image_name   = v.image_name
      flavor_name  = v.flavor_name
      key_pair     = v.key_pair
      volume_id = (
        v.volume_name != null ? module.volume.volume_ids[v.volume_name] :
        v.volume_size != null ? module.volume.volume_ids["${k}-vol"] :
        v.volume_id
      )
      extra_volume_ids = v.extra_volumes != null ? [
        for ev in v.extra_volumes :
        ev.volume_name != null ? module.volume.volume_ids[ev.volume_name] : ev.volume_id
      ] : null
      ports = v.ports
    }
  }
}
