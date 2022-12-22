variable "default_tags" {
  type    = map(string)
  default = {}
}
variable "private_endpoint_resource_group" {
  description = "Apply the resource group to all pe if they are not provide individually. (This var is not implement.)"
  type        = string
  default     = null
}

variable "private_endpoints" {
  type = map(object({
    resource_group_name      = string
    location                 = string
    vnet_name                = string
    vnet_resource_group_name = optional(string)
    subnet_name              = string

    private_dns_zone_group = optional(object({
      name                                 = string
      private_dns_zone_names               = optional(set(string))
      private_dns_zone_resource_group_name = optional(string)
      private_dns_zone_ids                 = optional(set(string))
    }))

    private_service_connection = object({
      name                              = string
      is_manual_connection              = bool
      private_connection_resource_id    = optional(string)
      private_connection_resource_alias = optional(string)
      subresource_names                 = optional(set(string))
      request_message                   = optional(string)
    })

    tags = map(string)
  }))
}
