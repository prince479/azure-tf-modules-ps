variable "default_tags" {
  type        = map(string)
  description = "Default Tags"
  default     = {}
}

variable "route_tables" {
  type = map(object({
    resource_group_name = string
    location            = string

    subnet_names_association = optional(map(object({
      vnet_name           = string
      resource_group_name = string
    })))

    routes = optional(map(object({
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = string
    })))

    tags = map(string)

  }))
}
