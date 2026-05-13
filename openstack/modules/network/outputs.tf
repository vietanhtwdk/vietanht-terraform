output "network_id" {
  value = var.network_id != null ? var.network_id : openstack_networking_network_v2.network[0].id
}

output "subnet_id" {
  value = var.network_id != null ? null : openstack_networking_subnet_v2.subnet[0].id
}

