terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.4.0"
    }
  }
}

resource "openstack_networking_port_v2" "port" {
  for_each = { for k, v in var.ports : k => v if v.id == null }

  name           = each.key
  network_id     = each.value.network_id
  admin_state_up = true

  dynamic "fixed_ip" {
    for_each = each.value.ip != null ? [each.value.ip] : []
    content {
      ip_address = fixed_ip.value
    }
  }

  security_group_ids = length(each.value.security_group_ids) > 0 ? each.value.security_group_ids : null
}
