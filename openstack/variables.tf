variable "auth_url" {
  description = "The Authentication URL for OpenStack"
  type        = string
}

variable "region" {
  description = "The region of the OpenStack cloud"
  type        = string
  default     = "RegionOne"
}

variable "tenant_name" {
  description = "The name of the project/tenant"
  type        = string
}

variable "user_name" {
  description = "The user name for OpenStack"
  type        = string
}

variable "password" {
  description = "The password for OpenStack"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "The domain name for OpenStack"
  type        = string
  default     = "Default"
}

variable "network_config" {
  description = "Network configuration"
  type = object({
    name         = string
    cidr         = string
    gateway_ip   = string
    external_net = string
  })
}

variable "vms" {
  description = "List of VMs to create"
  type = map(object({
    image_name = string
    flavor_name = string
    key_pair   = string
  }))
}
