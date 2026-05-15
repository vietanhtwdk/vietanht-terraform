# This is a sample integration test configuration
# It would normally be run with terraform init/plan/apply in this directory

module "test_setup" {
  source = "../"

  # Mock variables for testing
  auth_url    = "http://localhost:5000/v3"
  tenant_name = "admin"
  user_name   = "admin"
  password    = "secret"

  networks = {
    "test-net" = {
      name = "test-net"
      cidr = "10.0.0.0/24"
    }
  }

  security_groups = {
    "test-sg" = {
      rules = [
        { direction = "ingress", protocol = "tcp", port_min = 22, port_max = 22, remote_ip_prefix = "0.0.0.0/0" },
      ]
    }
  }

  volumes = {
    "test-vol" = {
      size       = 10
      image_name = "ubuntu-22.04"
    }
  }

  vms = {
    "test-vm" = {
      flavor_name          = "m1.small"
      volume_name          = "test-vol"
      security_group_names = ["test-sg"]
      ports = [
        { network_name = "test-net" }
      ]
    }
  }
}
