
variable "location" {
  type        = string
  description = "Default location for all resource group"
  default     = null
}

variable "resource_group" {
  type        = string
  description = "Default Resource group"
  default     = null
}

variable "tags" {
  type        = string
  description = "Default tags for all resource group"
  default     = null
}
variable "storage_accounts" {
  type = map(object({
    resource_group_name      = string
    location                 = string
    account_tier             = string
    access_tier              = optional(string)
    account_replication_type = string
    account_kind             = optional(string)

    enable_https_traffic_only = optional(bool)
    min_tls_version           = optional(string)

    shared_access_key_enabled = optional(bool)

    allow_nested_items_to_be_public  = optional(bool)
    cross_tenant_replication_enabled = optional(bool)
    edge_zone                        = optional(string)

    infrastructure_encryption_enabled = optional(bool)
    is_hns_enabled                    = optional(bool)
    large_file_share_enabled          = optional(bool)
    nfsv3_enabled                     = optional(bool)

    blob_properties = optional(object({
      change_feed_enabled      = optional(bool)
      default_service_version  = optional(string)
      last_access_time_enabled = optional(bool)
      versioning_enabled       = optional(bool)

      container_delete_retention_policy = optional(object({
        days = number
      }))
      cors_rule = optional(object({
        allowed_headers    = optional(set(string))
        allowed_methods    = optional(set(string))
        allowed_origins    = optional(set(string))
        exposed_headers    = optional(set(string))
        max_age_in_seconds = optional(number)
      }))
      delete_retention_policy = optional(object({
        days = number
      }))
    }))

    identity = optional(object({
      identity_ids = string
      type         = string
    }))

    azure_files_authentication = optional(object({
      directory_type = string
      active_directory = optional(object({
        storage_sid         = string
        netbios_domain_name = string
        domain_guid         = string
        domain_name         = string
        domain_sid          = string
        forest_name         = string
      }))
    }))

    custom_domain = optional(object({
      name          = string
      use_subdomain = optional(bool)
    }))

    customer_managed_key = optional(object({
      key_vault_key_id          = string
      user_assigned_identity_id = string
    }))

    network_rules = optional(map(object({
      default_action = string
      bypass         = optional(string)
      ip_rules       = optional(set(string))

      virtual_network_subnet_ids = optional(set(string))

      private_link_access = optional(set(object({
        endpoint_resource_id = string
        endpoint_tenant_id   = optional(string)
      })))
    })))

    storage_containers = optional(map(object({
      container_access_type = optional(string)
      metadata              = optional(map(string))
    })))

    storage_fileshares = optional(map(object({
      quota       = number
      access_tier = optional(string)
    })))

    tags = optional(map(string))

  }))
}
