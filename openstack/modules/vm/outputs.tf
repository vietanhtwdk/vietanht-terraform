output "vm_ips" {
  value = {
    for k, v in openstack_compute_instance_v2.vm : k => v.access_ip_v4
  }
}
