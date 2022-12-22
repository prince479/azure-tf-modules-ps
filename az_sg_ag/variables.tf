variable "default_location" {
  type    = string
  default = null
}
variable "default_resource_group_name" {
  type    = string
  default = null
}
variable "application_security_groups" {
  type = map(object({
    location            = optional(string)
    resource_group_name = optional(string)

    tags = map(string)

  }))
}

variable "default_tags" {
  type    = map(string)
  default = {}
}

variable "network_security_groups" {
  type = map(object({
    resource_group_name = optional(string)
    location            = optional(string)

    security_rules = map(object({
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
      }
    ))

    subnet_association_ids = optional(set(string))

    tags = map(string)
  }))
}
