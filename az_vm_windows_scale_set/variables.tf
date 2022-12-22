variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}

variable "default_tags" {
  type    = map(string)
  default = {}
}

variable "az_vm_windows_scale_set" {
  type = map(object({
    resource_group_name  = optional(string)
    location             = optional(string)
    computer_name_prefix = optional(string) # If vmss name is more than 9 chars, you need to provide prefix which is not exceed 9 chars
    admin_username       = string
    instances            = number
    sku                  = string

    custom_data          = optional(string)
    custom_data_fromfile = optional(string)
    user_data            = optional(string)
    user_data_fromfile   = optional(string)

    priority        = optional(string)
    eviction_policy = optional(string)

    zones        = optional(set(string))
    zone_balance = optional(bool)
    vtpm_enabled = optional(bool)

    #Possible values are Automatic, Manual and Rolling. Defaults to Manual.
    upgrade_mode = optional(string)

    additional_capabilities = optional(object({
      ultra_ssd_enabled = optional(string)
    }))

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

    rolling_upgrade_policy = optional(object({
      max_batch_instance_percent              = number
      max_unhealthy_instance_percent          = number
      max_unhealthy_upgraded_instance_percent = number
      pause_time_between_batches              = string
    }))

    network_interfaces = map(object({
      enable_accelerated_networking = optional(bool)
      network_security_group_id     = optional(string)
      primary                       = optional(bool)
      dns_servers                   = optional(set(string))
      enable_ip_forwarding          = optional(bool)

      ip_configuration = object({
        name                                         = string
        primary                                      = optional(bool)
        vnet_name                                    = optional(string)
        subnet_name                                  = optional(string)
        vnet_resource_group_name                     = optional(string)
        subnet_id                                    = optional(string)
        application_gateway_backend_address_pool_ids = optional(set(string))
        application_security_group_ids               = optional(set(string))

        # This block is used to find load_balancer_backend_address_pool data.
        # if provide load_balancer_backend_address_pool_ids, this block will be ignored.
        load_balancers = optional(map(object({
          load_balancer_resource_group_name        = string
          load_balancer_backend_address_pool_names = optional(set(string))
          load_balancer_inbound_nat_rules_names    = optional(set(string))
        })))

        load_balancer_backend_address_pool_ids = optional(set(string))
        load_balancer_inbound_nat_rules_ids    = optional(set(string))

        version = optional(string)
        public_ip_address = optional(object({
          name                    = string
          domain_name_label       = optional(string)
          idle_timeout_in_minutes = optional(number)

          # map name is the tag name
          ip_tag = optional(map(object({
            type = string
          })))

          public_ip_prefix_id = optional(string)
        }))
      })
    }))

    tags = optional(map(string))
  }))
}

variable "public_key_from_env" {
  type    = string
  default = null
}

variable "windows_admin_password" {
  type    = string
  default = null
}
