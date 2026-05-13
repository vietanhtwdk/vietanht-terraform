variable "volumes" {
  description = "Map of volumes to create"
  type = map(object({
    size       = number
    image_name = optional(string)
  }))
  default = {}
}
