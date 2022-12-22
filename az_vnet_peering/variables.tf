variable "vnet_peers" {
  type = map(object({
    resource_group_name  = string
    virtual_network_name = string

    remote_virtual_network_name                = optional(string)
    remote_virtual_network_resource_group_name = optional(string)
    remote_virtual_network_id                  = optional(string)

    allow_virtual_network_access = optional(bool)
    allow_forwarded_traffic      = optional(bool)
    allow_gateway_transit        = optional(bool)
    use_remote_gateways          = optional(bool)
  }))
}
