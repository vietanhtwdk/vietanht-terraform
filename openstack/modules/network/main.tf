terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.4.0"
    }
  }
}

resource "openstack_networking_network_v2" "network" {
  name           = var.network_name
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet" {
  name       = "${var.network_name}_subnet"
  network_id = openstack_networking_network_v2.network.id
  cidr       = var.cidr
  ip_version = 4
  gateway_ip = var.gateway_ip
}

resource "openstack_networking_router_v2" "router" {
  name                = "${var.network_name}_router"
  admin_state_up      = true
  external_network_id = var.external_network_id
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.subnet.id
}
