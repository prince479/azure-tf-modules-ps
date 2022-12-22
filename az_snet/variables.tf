variable "resource_group_name" {
  type        = string
  default     = null
  description = "Default ressource group name"
}

variable "virtual_network_name" {
  type        = string
  default     = null
  description = "Default virtual network name"
}

variable "subnets" {
  type = map(object({
    virtual_network_name = optional(string)
    resource_group_name  = optional(string)
    subnet_prefix        = list(string)
    service_endpoints    = optional(list(string))

    enforce_private_link_endpoint_network_policies = optional(bool)
    enforce_private_link_service_network_policies  = optional(bool)

    delegation = optional(object({
      name = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    }))
  }))
}
