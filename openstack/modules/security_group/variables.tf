variable "security_groups" {
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
}
