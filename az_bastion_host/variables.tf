
variable "bastion_hosts" {
  type = map(object({
    resource_group_name = string
    location            = string
    sku                 = string
    tunneling_enabled   = optional(bool) #only supported when sku is Standard

    copy_paste_enabled     = optional(bool)
    file_copy_enabled      = optional(bool)   #only supported when sku is Standard
    ip_connect_enabled     = optional(bool)   #only supported when sku is Standard
    scale_units            = optional(number) #only can be changed when sku is Standard.
    shareable_link_enabled = optional(bool)   #only supported when sku is Standard

    ip_configuration = object({
      vnet_name = string
    })
    tags = optional(map(string))
  }))

  default = null
}
