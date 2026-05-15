variable "vms" {
  type = map(object({
    image_name         = optional(string)
    flavor_name        = string
    key_pair           = optional(string)
    volume_id          = optional(string)
    extra_volume_ids   = optional(list(string))
    security_group_ids = optional(list(string), [])
    ports = list(object({
      network_id = optional(string)
      ip         = optional(string)
      port_id    = optional(string)
    }))
  }))
}
