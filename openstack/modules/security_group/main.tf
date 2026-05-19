terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.4.0"
    }
  }
}

resource "openstack_networking_secgroup_v2" "sg" {
  for_each    = { for k, v in var.security_groups : k => v if v.id == null }
  name        = each.key
  description = each.value.description
}

locals {
  sg_rules = merge([
    for sg_name, sg in var.security_groups : {
      for idx, rule in sg.rules :
      "${sg_name}-rule-${idx}" => merge(rule, {
        sg_id = sg.id != null ? sg.id : openstack_networking_secgroup_v2.sg[sg_name].id
      })
    } if sg.id == null
  ]...)
}

resource "openstack_networking_secgroup_rule_v2" "rule" {
  for_each = local.sg_rules

  direction         = each.value.direction
  ethertype         = each.value.ethertype
  protocol          = each.value.protocol
  port_range_min    = each.value.port_min
  port_range_max    = each.value.port_max
  remote_ip_prefix  = each.value.remote_ip_prefix
  security_group_id = each.value.sg_id
}
