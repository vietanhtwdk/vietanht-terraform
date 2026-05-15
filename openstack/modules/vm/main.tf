terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.4.0"
    }
  }
}

locals {
  # All port entries that need a new port resource (no pre-existing port_id)
  ports_to_create = {
    for item in flatten([
      for vm_name, vm in var.vms : [
        for idx, p in vm.ports : {
          key        = "${vm_name}-port-${idx}"
          vm_name    = vm_name
          idx        = tostring(idx)
          network_id = p.network_id
          ip         = p.ip
          sg_ids     = p.security_group_ids
        } if p.port_id == null
      ]
    ]) : item.key => item
  }
}

resource "openstack_networking_port_v2" "vm_port" {
  for_each = local.ports_to_create

  name           = each.key
  network_id     = each.value.network_id
  admin_state_up = true

  dynamic "fixed_ip" {
    for_each = each.value.ip != null ? [each.value.ip] : []
    content {
      ip_address = fixed_ip.value
    }
  }

  security_group_ids = length(each.value.sg_ids) > 0 ? each.value.sg_ids : null
}

resource "openstack_compute_instance_v2" "vm" {
  for_each = var.vms

  name        = each.key
  image_name  = each.value.volume_id == null ? each.value.image_name : null
  flavor_name = each.value.flavor_name
  key_pair    = each.value.key_pair

  dynamic "network" {
    for_each = { for idx, p in each.value.ports : tostring(idx) => p }
    content {
      port = network.value.port_id != null ? network.value.port_id : openstack_networking_port_v2.vm_port["${each.key}-port-${network.key}"].id
    }
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

  dynamic "block_device" {
    for_each = each.value.extra_volume_ids != null ? each.value.extra_volume_ids : []
    content {
      uuid                  = block_device.value
      source_type           = "volume"
      destination_type      = "volume"
      boot_index            = -1
      delete_on_termination = false
    }
  }
}
