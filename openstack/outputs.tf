output "vm_ips" {
  description = "IP addresses of the created VMs"
  value       = module.vm.vm_ips
}

output "network_ids" {
  description = "IDs of the created/referenced networks, keyed by network label"
  value       = { for k, v in module.networks : k => v.network_id }
}

output "port_ids" {
  description = "IDs of the named ports, keyed by port label"
  value       = local.port_ids
}
