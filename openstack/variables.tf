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

variable "networks" {
  description = "Map of networks to create or reference. Key is used as the network label referenced in VM port entries."
  type = map(object({
    name         = string
    cidr         = optional(string)
    gateway_ip   = optional(string)
    external_net = optional(string)
    id           = optional(string)
  }))
  default = {}
}

variable "security_groups" {
  description = "Map of security groups to create or reference. Key becomes the SG name when creating. Set id to reference an existing SG without creating it (rules are ignored for existing SGs)."
  type = map(object({
    description = optional(string, "Managed security group")
    id          = optional(string)
    rules = optional(list(object({
      direction        = string
      ethertype        = optional(string, "IPv4")
      protocol         = optional(string)
      port_min         = optional(number)
      port_max         = optional(number)
      remote_ip_prefix = optional(string)
    })), [])
  }))
  default = {}
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
  description = "Map of VMs to create"
  type = map(object({
    image_name    = optional(string)
    flavor_name   = string
    key_pair      = optional(string)
    volume_id     = optional(string)
    volume_name   = optional(string)
    volume_size   = optional(number)
    extra_volumes = optional(list(object({
      volume_name = optional(string)
      volume_id   = optional(string)
    })))
    security_group_names = optional(list(string), [])
    security_group_ids   = optional(list(string), [])
    ports = list(object({
      network_name         = optional(string)
      ip                   = optional(string)
      port_id              = optional(string)
      security_group_names = optional(list(string))
      security_group_ids   = optional(list(string), [])
    }))
  }))
}