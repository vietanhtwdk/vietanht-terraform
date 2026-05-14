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
    cidr         = optional(string)
    gateway_ip   = optional(string)
    external_net = optional(string)
    id           = optional(string)
  })
}

variable "create_security_group" {
  description = "Whether to create a new security group"
  type        = bool
  default     = true
}


variable "volumes" {
  description = "Map of volumes to create"
  type = map(object({
    size       = number
    image_name = optional(string)
  }))
  default = {}
}

variable "vms" {
  description = "List of VMs to create"
  type = map(object({
    image_name  = optional(string)
    flavor_name = string
    key_pair    = optional(string)
    ip          = optional(string)
    port_id     = optional(string)
    volume_id   = optional(string)
    volume_name = optional(string)
  }))
}

