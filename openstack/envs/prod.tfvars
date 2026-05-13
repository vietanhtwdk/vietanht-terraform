auth_url    = "http://openstack.example.com:5000/v3"
tenant_name = "prod-project"
user_name   = "prod-user"
password    = "prod-password"

network_config = {
  name         = "prod-net"
  cidr         = "10.0.3.0/24"
  gateway_ip   = "10.0.3.1"
  external_net = "external-net-id"
}

vms = {
  "web-prod-1" = {
    image_name  = "Ubuntu 22.04"
    flavor_name = "m1.large"
    key_pair    = "prod-key"
  },
  "web-prod-2" = {
    image_name  = "Ubuntu 22.04"
    flavor_name = "m1.large"
    key_pair    = "prod-key"
  },
  "db-prod-master" = {
    image_name  = "Ubuntu 22.04"
    flavor_name = "m1.xlarge"
    key_pair    = "prod-key"
  }
}
