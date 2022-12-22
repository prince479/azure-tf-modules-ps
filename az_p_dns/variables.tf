variable "default_tags" {
  type        = map(string)
  description = "Default Tags"
  default     = {}
}

variable "private_dns_zones" {
  type = map(object({
    resource_group_name = string
    tags                = map(string)

    vnet_link_names = map(object({
      registration_enabled = optional(bool)
      resource_group_name  = optional(string)
      virtual_network_id   = optional(string)
      inherit_tags         = optional(bool) #inherit tags from private dns zones
      tags                 = optional(map(string))
    }))

    soa_record = optional(object({
      email        = string
      expire_time  = optional(number)
      minimum_ttl  = optional(number)
      refresh_time = optional(number)
      retry_time   = optional(number)
      ttl          = optional(number)
    }))

    a_records = optional(map(object({
      ttl     = number
      records = set(string)
    })))

    cname_records = optional(map(object({
      ttl    = number
      record = string
    })))

  }))
}
