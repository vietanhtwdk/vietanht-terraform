variable "vms" {
  type = map(object({
    image_name       = optional(string)
    flavor_name      = string
    key_pair         = optional(string)
    ip               = optional(string)
    port_id          = optional(string)
    volume_id        = optional(string)
    extra_volume_ids = optional(list(string))
  }))
}


variable "network_id" {
  type = string
}

variable "security_group_name" {
  type    = string
  default = null
}

variable "security_group_id" {
  type    = string
  default = null
}

