terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.4.0"
    }
  }
}

resource "openstack_networking_secgroup_v2" "sg" {
  count       = var.enabled ? 1 : 0
  name        = var.sg_name
  description = "Basic security group for VMs"
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  count             = var.enabled ? 1 : 0
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.sg[0].id
}

resource "openstack_networking_secgroup_rule_v2" "http" {
  count             = var.enabled ? 1 : 0
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.sg[0].id
}
