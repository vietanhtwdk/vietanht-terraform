variable "vms" {
  type = map(object({
    image_name = string
    flavor_name = string
    key_pair   = optional(string)
  }))
}

variable "network_id" {
  type = string
}

variable "security_group_name" {
  type    = string
  default = null
}

