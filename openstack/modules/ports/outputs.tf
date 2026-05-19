output "port_ids" {
  description = "Map of port label to ID"
  value = {
    for k, v in var.ports :
    k => v.id != null ? v.id : openstack_networking_port_v2.port[k].id
  }
}
