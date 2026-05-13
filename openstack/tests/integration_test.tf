# This is a sample integration test configuration
# It would normally be run with terraform init/plan/apply in this directory

module "test_setup" {
  source = "../"

  # Mock variables for testing
  auth_url    = "http://localhost:5000/v3"
  tenant_name = "admin"
  user_name   = "admin"
  password    = "secret"

  network_config = {
    name = "test-net"
    cidr = "10.0.0.0/24"
  }

  volumes = {
    "test-vol" = {
      size       = 10
      image_name = "ubuntu-22.04"
    }
  }

  vms = {
    "test-vm" = {
      flavor_name = "m1.small"
      volume_id   = "mock-volume-id" # In a real test, this could be linked to module.volume.volume_ids["test-vol"]
    }
  }
}
