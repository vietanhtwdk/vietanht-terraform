module "network" {
  source = "./modules/network"

  network_name        = var.network_config.name
  cidr                = var.network_config.cidr
  gateway_ip          = var.network_config.gateway_ip
  external_network_id = var.network_config.external_net
  network_id          = var.network_config.id
}

module "security_group" {
  source = "./modules/security_group"

  enabled = var.create_security_group
  sg_name = "${var.network_config.name}-sg"
}

locals {
  auto_volumes = {
    for k, v in var.vms : "${k}-vol" => {
      size       = v.volume_size
      image_name = v.image_name
    } if v.volume_size != null
  }

  all_volumes = merge(var.volumes, local.auto_volumes)
}

module "volume" {
  source = "./modules/volume"

  volumes = local.all_volumes
}

module "vm" {
  source = "./modules/vm"

  vms = { for k, v in var.vms : k => merge(v, {
    volume_id = (
      v.volume_name != null ? module.volume.volume_ids[v.volume_name] :
      v.volume_size != null ? module.volume.volume_ids["${k}-vol"] :
      v.volume_id
    )
  }) }
  network_id          = module.network.network_id
  security_group_name = module.security_group.sg_name
  security_group_id   = module.security_group.sg_id
}


