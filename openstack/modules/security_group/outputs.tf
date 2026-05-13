output "sg_name" {
  value = var.enabled ? openstack_networking_secgroup_v2.sg[0].name : null
}

output "sg_id" {
  value = var.enabled ? openstack_networking_secgroup_v2.sg[0].id : null
}

