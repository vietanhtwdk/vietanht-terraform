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
  # Import an existing SG (managed externally) — no rules block needed
  "prod-monitoring-sg" = {
    id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
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
    # VM-level direct UUID: applied to every port on this VM
    security_group_ids   = ["xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"]
    ports = [
      {
        # Front-facing port: web SG + monitoring SG (named) + VM-level direct ID
        network_name         = "prod-frontend"
        security_group_names = ["prod-web-sg", "prod-monitoring-sg"]
      },
      {
        # DB port: db SG (overrides VM-level names) + extra direct ID for this port only
        network_name         = "prod-backend"
        ip                   = "10.0.4.10"
        security_group_names = ["prod-db-sg"]
        security_group_ids   = ["yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy"]
      },
    ]
  }
}
