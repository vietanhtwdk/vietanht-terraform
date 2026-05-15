output "security_group_ids" {
  description = "Map of security group label to ID"
  value = {
    for k, v in var.security_groups :
    k => v.id != null ? v.id : openstack_networking_secgroup_v2.sg[k].id
  }
}
