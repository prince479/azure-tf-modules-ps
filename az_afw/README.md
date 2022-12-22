# az_afw

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_firewall.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall) | resource |
| [azurerm_firewall_policy.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy) | resource |
| [azurerm_firewall_policy_rule_collection_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy_rule_collection_group) | resource |
| [azurerm_public_ip.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_subnet.snet_for_ipconf](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_firewall_policies"></a> [azure\_firewall\_policies](#input\_azure\_firewall\_policies) | n/a | <pre>map(object({<br>    associated_to_afw_name = optional(string)<br>    resource_group_name    = string<br>    location               = string<br><br>    base_policy_id = optional(string)<br>    dns            = optional(string)<br><br>    identity = optional(object({<br>      type         = string<br>      identity_ids = optional(string)<br>    }))<br>    insights = optional(object({<br>      enabled                            = bool<br>      default_log_analytics_workspace_id = string<br>      retention_in_days                  = optional(number)<br>      log_analytics_workspace = optional(map(object({<br>        id                = string<br>        firewall_location = string<br>      })))<br>    }))<br><br>    intrusion_detection = optional(object({<br>      mode = optional(string)<br>      signature_overrides = optional(map(object({<br>        id    = optional(string)<br>        state = optional(string)<br>      })))<br>      traffic_bypass = optional(map(object({<br>        protocol              = string<br>        description           = optional(string)<br>        destination_addresses = optional(set(string))<br>        destination_ip_groups = optional(set(string))<br>        destination_ports     = optional(set(number))<br>        source_addresses      = optional(set(string))<br>        source_ip_groups      = optional(set(string))<br>      })))<br>    }))<br><br>    private_ip_ranges = optional(set(string))<br><br>    sku  = optional(string)<br>    tags = map(string)<br><br>    threat_intelligence_allowlist = optional(object({<br>      fqdns        = optional(set(string))<br>      ip_addresses = optional(set(string))<br>    }))<br><br>    threat_intelligence_mode = optional(string)<br><br>    tls_certificate = optional(object({<br>      name                = string<br>      key_vault_secret_id = string<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_azure_firewalls"></a> [azure\_firewalls](#input\_azure\_firewalls) | n/a | <pre>map(object({<br>    resource_group_name = string<br>    location            = string<br><br>    sku_name           = optional(string)<br>    sku_tier           = optional(string)<br>    firewall_policy_id = optional(string)<br>    threat_intel_mode  = optional(string)<br><br>    ip_configuration = optional(map(object({<br><br>      #if you use subnet_id or public_ip_address_id, subnet_name, vnet_name, vnet_resource_group_name will be ignored.<br>      subnet_id            = optional(string)<br>      public_ip_address_id = optional(string)<br><br>      #if you specify this variable, it will automatically generate pip.<br>      public_name              = optional(string)<br>      subnet_name              = optional(string)<br>      vnet_name                = optional(string)<br>      vnet_resource_group_name = optional(string)<br>    })))<br><br>    tags = map(string)<br>  }))</pre> | n/a | yes |
| <a name="input_azurerm_firewall_policy_rule_collection_group"></a> [azurerm\_firewall\_policy\_rule\_collection\_group](#input\_azurerm\_firewall\_policy\_rule\_collection\_group) | n/a | <pre>map(object({<br>    associated_to_afw_policy_name = optional(string)<br>    firewall_policy_id            = optional(string)<br><br>    priority = number<br><br>    application_rule_collection = optional(map(object({<br>      action   = string<br>      priority = number<br>      rule = map(object({<br>        description = optional(string)<br>        protocols = optional(map(object({<br>          # Possible values of name are Http and Https.<br>          port = number<br>        })))<br><br>        source_addresses      = optional(set(string))<br>        source_ip_groups      = optional(set(string))<br>        destination_addresses = optional(set(string))<br>        destination_urls      = optional(set(string))<br>        destination_fqdns     = optional(set(string))<br>        destination_fqdn_tags = optional(set(string))<br>        terminate_tls         = optional(bool)<br>        web_categories        = optional(set(string))<br><br>      }))<br>    })))<br><br>    network_rule_collection = optional(map(object({<br>      action   = string<br>      priority = number<br>      rule = map(object({<br>        description = optional(string)<br>        protocols = optional(map(object({<br>          # Possible values of name are Http and Https.<br>          port = number<br>        })))<br>      }))<br>    })))<br><br>    nat_rule_collection = optional(map(object({<br>      action   = string<br>      priority = number<br>      rule = map(object({<br>        description = optional(string)<br>        protocols = optional(map(object({<br>          # Possible values of name are Http and Https.<br>          port = number<br>        })))<br>      }))<br>    })))<br><br>  }))</pre> | `{}` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | n/a | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_az_firewall_result"></a> [az\_firewall\_result](#output\_az\_firewall\_result) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
