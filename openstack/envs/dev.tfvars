auth_url    = "http://openstack.example.com:5000/v3"
tenant_name = "dev-project"
user_name   = "dev-user"
password    = "dev-password"

networks = {
  "dev-net" = {
    name         = "dev-net"
    cidr         = "10.0.1.0/24"
    gateway_ip   = "10.0.1.1"
    external_net = "external-net-id"
  }
}

security_groups = {
  "dev-sg" = {
    rules = [
      { direction = "ingress", protocol = "tcp", port_min = 22, port_max = 22, remote_ip_prefix = "0.0.0.0/0" },
      { direction = "ingress", protocol = "tcp", port_min = 80, port_max = 80, remote_ip_prefix = "0.0.0.0/0" },
    ]
  }
}

vms = {
  "web-server-dev" = {
    image_name           = "Ubuntu 22.04"
    flavor_name          = "m1.small"
    key_pair             = "dev-key"
    security_group_names = ["dev-sg"]
    ports = [
      { network_name = "dev-net" }
    ]
  },
  "db-server-dev" = {
    image_name           = "Ubuntu 22.04"
    flavor_name          = "m1.medium"
    key_pair             = "dev-key"
    security_group_names = ["dev-sg"]
    ports = [
      { network_name = "dev-net" }
    ]
  }
}
