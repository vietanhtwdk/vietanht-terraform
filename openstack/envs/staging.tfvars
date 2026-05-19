auth_url    = "http://openstack.example.com:5000/v3"
tenant_name = "staging-project"
user_name   = "staging-user"
password    = "staging-password"

networks = {
  "staging-net" = {
    name         = "staging-net"
    cidr         = "10.0.2.0/24"
    gateway_ip   = "10.0.2.1"
    external_net = "external-net-id"
  }
}

security_groups = {
  "staging-sg" = {
    rules = [
      { direction = "ingress", protocol = "tcp", port_min = 22, port_max = 22, remote_ip_prefix = "0.0.0.0/0" },
      { direction = "ingress", protocol = "tcp", port_min = 80, port_max = 80, remote_ip_prefix = "0.0.0.0/0" },
    ]
  }
}

vms = {
  "app-staging-1" = {
    image_name           = "Ubuntu 22.04"
    flavor_name          = "m1.medium"
    key_pair             = "staging-key"
    security_group_names = ["staging-sg"]
    ports = [
      { network_name = "staging-net" }
    ]
  }
}
