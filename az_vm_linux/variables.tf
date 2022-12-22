variable "resource_group_name" {
  type = string
}
/*
variable "backup_resource_group_name" {
  type = string
}

variable "recovery_vault_name" {
  type = string
}

variable "backup_policy_name" {
  type = string
}*/
variable "location" {
  type = string
}
variable "default_tags" {
  type    = map(string)
  default = {}
}
variable "az_vm_linux" {
  type = map(object({
    computer_name        = optional(string)
    size                 = string
    admin_username       = optional(string)
    admin_password       = optional(string)
    custom_data          = optional(string)
    custom_data_fromfile = optional(string)
    user_data            = optional(string)
    user_data_fromfile   = optional(string)
    priority             = optional(string)
    eviction_policy      = optional(string)
    disable_password_authentication = optional(bool)

    /*admin_ssh_key = object({
      username             = string
      public_key           = optional(string)
      public_key_from_file = optional(string)
    })*/

    os_disk = object({
      caching                = string
      storage_account_type   = string
      disk_size_gb           = optional(number)
      disk_encryption_set_id = optional(string)
    })

    source_image_reference = optional(object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    }))
    source_image_id = optional(string)

    network_interfaces = map(object({
      name                          = optional(string) # Override name
      enable_accelerated_networking = optional(bool) 
      enable_public_ip              = optional(bool) # default: false
      public_ip_allocation_method   = optional(string)
      resource_group_name           = optional(string)

      ip_configuration = object({
        name                          = string
        vnet_name                     = optional(string)
        subnet_name                   = optional(string)
        vnet_resource_group_name      = optional(string)
        private_ip_address_allocation = optional(string)
        public_ip_address_id          = optional(string)
        private_ip_address            = optional(string)
        subnet_id                     = optional(string)
      })
    }))

    tags = optional(map(string))

  }))
}

variable "public_key_from_env" {
  type    = string
  default = null
}

variable "linux_admin_password" {
  type    = string
  default = null
}
