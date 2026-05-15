auth_url    = "http://openstack.example.com:5000/v3"
tenant_name = "prod-project"
user_name   = "prod-user"
password    = "prod-password"

networks = {
  "prod-frontend" = {
    name         = "prod-frontend"
    cidr         = "10.0.3.0/24"
    gateway_ip   = "10.0.3.1"
    external_net = "external-net-id"
  }
  "prod-backend" = {
    name         = "prod-backend"
    cidr         = "10.0.4.0/24"
    gateway_ip   = "10.0.4.1"
    external_net = "external-net-id"
  }
}

security_groups = {
  "prod-web-sg" = {
    rules = [
      { direction = "ingress", protocol = "tcp", port_min = 22,  port_max = 22,  remote_ip_prefix = "10.0.0.0/8" },
      { direction = "ingress", protocol = "tcp", port_min = 80,  port_max = 80,  remote_ip_prefix = "0.0.0.0/0" },
      { direction = "ingress", protocol = "tcp", port_min = 443, port_max = 443, remote_ip_prefix = "0.0.0.0/0" },
    ]
  }
  "prod-db-sg" = {
    rules = [
      { direction = "ingress", protocol = "tcp", port_min = 22,   port_max = 22,   remote_ip_prefix = "10.0.0.0/8" },
      { direction = "ingress", protocol = "tcp", port_min = 5432, port_max = 5432, remote_ip_prefix = "10.0.4.0/24" },
    ]
  }
}

vms = {
  "web-prod-1" = {
    image_name           = "Ubuntu 22.04"
    flavor_name          = "m1.large"
    key_pair             = "prod-key"
    security_group_names = ["prod-web-sg"]
    ports = [
      { network_name = "prod-frontend" }
    ]
  },
  "web-prod-2" = {
    image_name           = "Ubuntu 22.04"
    flavor_name          = "m1.large"
    key_pair             = "prod-key"
    security_group_names = ["prod-web-sg"]
    ports = [
      { network_name = "prod-frontend" }
    ]
  },
  "db-prod-master" = {
    image_name           = "Ubuntu 22.04"
    flavor_name          = "m1.xlarge"
    key_pair             = "prod-key"
    security_group_names = ["prod-db-sg"]
    ports = [
      { network_name = "prod-frontend" },
      { network_name = "prod-backend", ip = "10.0.4.10" },
    ]
  }
}
