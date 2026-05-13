terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.4.0"
    }
  }
}

resource "openstack_compute_instance_v2" "vm" {
  for_each = var.vms

  name            = each.key
  image_name      = each.value.image_name
  flavor_name     = each.value.flavor_name
  key_pair        = each.value.key_pair
  security_groups = [var.security_group_name]

  network {
    uuid = var.network_id
  }
}
