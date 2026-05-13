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

module "vm" {
  source = "./modules/vm"

  vms                 = var.vms
  network_id          = module.network.network_id
  security_group_name = module.security_group.sg_name
  security_group_id   = module.security_group.sg_id
}
