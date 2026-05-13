output "volume_ids" {
  description = "Map of volume names to IDs"
  value       = { for k, v in openstack_blockstorage_volume_v3.volume : k => v.id }
}
