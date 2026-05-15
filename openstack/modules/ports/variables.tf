variable "ports" {
  type = map(object({
    id                 = optional(string)
    network_id         = optional(string)
    ip                 = optional(string)
    security_group_ids = optional(list(string), [])
  }))
}
