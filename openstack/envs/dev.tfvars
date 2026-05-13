auth_url    = "http://openstack.example.com:5000/v3"
tenant_name = "dev-project"
user_name   = "dev-user"
password    = "dev-password"

network_config = {
  name         = "dev-net"
  cidr         = "10.0.1.0/24"
  gateway_ip   = "10.0.1.1"
  external_net = "external-net-id"
}

vms = {
  "web-server-dev" = {
    image_name  = "Ubuntu 22.04"
    flavor_name = "m1.small"
    key_pair    = "dev-key"
  },
  "db-server-dev" = {
    image_name  = "Ubuntu 22.04"
    flavor_name = "m1.medium"
    key_pair    = "dev-key"
  }
}
