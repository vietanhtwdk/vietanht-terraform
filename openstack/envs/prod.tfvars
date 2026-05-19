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
  # Import existing network by ID — name is not required
  "prod-mgmt" = {
    id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
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

# Named ports: create or import, then reference by label in VM port entries
ports = {
  # Import an existing port (e.g. pre-provisioned with a reserved IP)
  "db-reserved-port" = {
    id = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
  }
  # Create a named port outside the VM (useful for floating-IP association, etc.)
  "lb-frontend-port" = {
    network_name         = "prod-frontend"
    ip                   = "10.0.3.100"
    security_group_names = ["prod-web-sg"]
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
    ports = [
      # Reference named port by label — uses the pre-created lb-frontend-port
      { port_name = "lb-frontend-port" }
    ]
  },
  "db-prod-master" = {
    image_name           = "Ubuntu 22.04"
    flavor_name          = "m1.xlarge"
    key_pair             = "prod-key"
    # VM-level direct UUID: applied to every inline port on this VM
    security_group_ids   = ["xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"]
    ports = [
      {
        # Front-facing port: web SG + monitoring SG (named) + VM-level direct ID
        network_name         = "prod-frontend"
        security_group_names = ["prod-web-sg", "prod-monitoring-sg"]
      },
      {
        # Use imported named port for the DB NIC (pre-reserved IP, externally managed)
        port_name = "db-reserved-port"
      },
    ]
  }
}
