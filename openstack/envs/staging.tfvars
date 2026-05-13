auth_url    = "http://openstack.example.com:5000/v3"
tenant_name = "staging-project"
user_name   = "staging-user"
password    = "staging-password"

network_config = {
  name         = "staging-net"
  cidr         = "10.0.2.0/24"
  gateway_ip   = "10.0.2.1"
  external_net = "external-net-id"
}

vms = {
  "app-staging-1" = {
    image_name  = "Ubuntu 22.04"
    flavor_name = "m1.medium"
    key_pair    = "staging-key"
  }
}
