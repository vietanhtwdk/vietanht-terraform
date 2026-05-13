terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.4.0"
    }
  }
}

locals {
  image_names = toset([for v in var.volumes : v.image_name if v.image_name != null])
}

data "openstack_images_image_v2" "image" {
  for_each = local.image_names
  name     = each.value
}

resource "openstack_blockstorage_volume_v3" "volume" {
  for_each = var.volumes

  name     = each.key
  size     = each.value.size
  image_id = each.value.image_name != null ? data.openstack_images_image_v2.image[each.value.image_name].id : null
}
