terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.4.0"
    }
  }
}

resource "openstack_networking_port_v2" "vm_port" {
  for_each = { for k, v in var.vms : k => v if v.ip != null }

  name           = "${each.key}-port"
  network_id     = var.network_id
  admin_state_up = true

  fixed_ip {
    ip_address = each.value.ip
  }

  security_group_ids = var.security_group_id != null ? [var.security_group_id] : []
}

resource "openstack_compute_instance_v2" "vm" {
  for_each = var.vms

  name            = each.key
  image_name      = each.value.volume_id == null ? each.value.image_name : null
  flavor_name     = each.value.flavor_name
  key_pair        = each.value.key_pair
  security_groups = (each.value.ip == null && each.value.port_id == null && var.security_group_name != null) ? [var.security_group_name] : []

  network {
    port = each.value.ip != null ? openstack_networking_port_v2.vm_port[each.key].id : (each.value.port_id != null ? each.value.port_id : null)
    uuid = (each.value.ip == null && each.value.port_id == null) ? var.network_id : null
  }

  dynamic "block_device" {
    for_each = each.value.volume_id != null ? [each.value.volume_id] : []
    content {
      uuid                  = block_device.value
      source_type           = "volume"
      destination_type      = "volume"
      boot_index            = 0
      delete_on_termination = false
    }
  }
}


