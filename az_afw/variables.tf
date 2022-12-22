variable "default_tags" {
  type    = map(string)
  default = {}
}
variable "azure_firewalls" {
  type = map(object({
    resource_group_name = string
    location            = string

    sku_name           = optional(string)
    sku_tier           = optional(string)
    firewall_policy_id = optional(string)
    threat_intel_mode  = optional(string)

    ip_configuration = optional(map(object({

      #if you use subnet_id or public_ip_address_id, subnet_name, vnet_name, vnet_resource_group_name will be ignored.
      subnet_id            = optional(string)
      public_ip_address_id = optional(string)

      #if you specify this variable, it will automatically generate pip.
      public_name              = optional(string)
      subnet_name              = optional(string)
      vnet_name                = optional(string)
      vnet_resource_group_name = optional(string)
    })))

    tags = map(string)
  }))

}

variable "azure_firewall_policies" {
  type = map(object({
    associated_to_afw_name = optional(string)
    resource_group_name    = string
    location               = string

    base_policy_id = optional(string)
    dns            = optional(string)

    identity = optional(object({
      type         = string
      identity_ids = optional(string)
    }))
    insights = optional(object({
      enabled                            = bool
      default_log_analytics_workspace_id = string
      retention_in_days                  = optional(number)
      log_analytics_workspace = optional(map(object({
        id                = string
        firewall_location = string
      })))
    }))

    intrusion_detection = optional(object({
      mode = optional(string)
      signature_overrides = optional(map(object({
        id    = optional(string)
        state = optional(string)
      })))
      traffic_bypass = optional(map(object({
        protocol              = string
        description           = optional(string)
        destination_addresses = optional(set(string))
        destination_ip_groups = optional(set(string))
        destination_ports     = optional(set(number))
        source_addresses      = optional(set(string))
        source_ip_groups      = optional(set(string))
      })))
    }))

    private_ip_ranges = optional(set(string))

    sku  = optional(string)
    tags = map(string)

    threat_intelligence_allowlist = optional(object({
      fqdns        = optional(set(string))
      ip_addresses = optional(set(string))
    }))

    threat_intelligence_mode = optional(string)

    tls_certificate = optional(object({
      name                = string
      key_vault_secret_id = string
    }))
  }))

  default = {}
}

variable "azurerm_firewall_policy_rule_collection_group" {
  type = map(object({
    associated_to_afw_policy_name = optional(string)
    firewall_policy_id            = optional(string)

    priority = number

    application_rule_collection = optional(map(object({
      action   = string
      priority = number
      rule = map(object({
        description = optional(string)
        protocols = optional(map(object({
          # Possible values of name are Http and Https.
          port = number
        })))

        source_addresses      = optional(set(string))
        source_ip_groups      = optional(set(string))
        destination_addresses = optional(set(string))
        destination_urls      = optional(set(string))
        destination_fqdns     = optional(set(string))
        destination_fqdn_tags = optional(set(string))
        terminate_tls         = optional(bool)
        web_categories        = optional(set(string))

      }))
    })))

    network_rule_collection = optional(map(object({
      action   = string
      priority = number
      rule = map(object({
        description = optional(string)
        protocols = optional(map(object({
          # Possible values of name are Http and Https.
          port = number
        })))
      }))
    })))

    nat_rule_collection = optional(map(object({
      action   = string
      priority = number
      rule = map(object({
        description = optional(string)
        protocols = optional(map(object({
          # Possible values of name are Http and Https.
          port = number
        })))
      }))
    })))

  }))
  default = {}
}
