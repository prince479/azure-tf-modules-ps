variable "default_tags" {
  type    = map(string)
  default = {}
}
variable "nat_gateways" {
  type = map(object({
    resource_group_name = string
    location            = string

    sku_name         = optional(string)
    zones            = optional(list(string))
    ip_prefix_length = number

    associated_subnets = set(string)

    auto_create_public_ip = optional(bool)
    public_ip_spec = optional(object({
      name                = optional(string)
      resource_group_name = optional(string)
      allocation_method   = optional(string)
      sku                 = optional(string)
      tags                = optional(map(string))
    }))

    tags = map(string)
    })
  )
}
