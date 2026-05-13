output "vm_ips" {
  description = "IP addresses of the created VMs"
  value       = module.vm.vm_ips
}

output "network_id" {
  description = "ID of the created network"
  value       = module.network.network_id
}
