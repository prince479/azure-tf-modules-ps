# az_sta

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
| [azurerm_storage_account.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.containers](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_share.fileshares](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Default location for all resource group | `string` | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | Default Resource group | `string` | `null` | no |
| <a name="input_storage_accounts"></a> [storage\_accounts](#input\_storage\_accounts) | n/a | <pre>map(object({<br>    resource_group_name      = string<br>    location                 = string<br>    account_tier             = string<br>    access_tier              = optional(string)<br>    account_replication_type = string<br>    account_kind             = optional(string)<br><br>    enable_https_traffic_only = optional(bool)<br>    min_tls_version           = optional(string)<br><br>    shared_access_key_enabled = optional(bool)<br><br>    allow_nested_items_to_be_public  = optional(bool)<br>    cross_tenant_replication_enabled = optional(bool)<br>    edge_zone                        = optional(string)<br><br>    infrastructure_encryption_enabled = optional(bool)<br>    is_hns_enabled                    = optional(bool)<br>    large_file_share_enabled          = optional(bool)<br>    nfsv3_enabled                     = optional(bool)<br><br>    blob_properties = optional(object({<br>      change_feed_enabled      = optional(bool)<br>      default_service_version  = optional(string)<br>      last_access_time_enabled = optional(bool)<br>      versioning_enabled       = optional(bool)<br><br>      container_delete_retention_policy = optional(object({<br>        days = number<br>      }))<br>      cors_rule = optional(object({<br>        allowed_headers    = optional(set(string))<br>        allowed_methods    = optional(set(string))<br>        allowed_origins    = optional(set(string))<br>        exposed_headers    = optional(set(string))<br>        max_age_in_seconds = optional(number)<br>      }))<br>      delete_retention_policy = optional(object({<br>        days = number<br>      }))<br>    }))<br><br>    identity = optional(object({<br>      identity_ids = string<br>      type         = string<br>    }))<br><br>    azure_files_authentication = optional(object({<br>      directory_type = string<br>      active_directory = optional(object({<br>        storage_sid         = string<br>        netbios_domain_name = string<br>        domain_guid         = string<br>        domain_name         = string<br>        domain_sid          = string<br>        forest_name         = string<br>      }))<br>    }))<br><br>    custom_domain = optional(object({<br>      name          = string<br>      use_subdomain = optional(bool)<br>    }))<br><br>    customer_managed_key = optional(object({<br>      key_vault_key_id          = string<br>      user_assigned_identity_id = string<br>    }))<br><br>    network_rules = optional(map(object({<br>      default_action = string<br>      bypass         = optional(string)<br>      ip_rules       = optional(set(string))<br><br>      virtual_network_subnet_ids = optional(set(string))<br><br>      private_link_access = optional(set(object({<br>        endpoint_resource_id = string<br>        endpoint_tenant_id   = optional(string)<br>      })))<br>    })))<br><br>    storage_containers = optional(map(object({<br>      container_access_type = optional(string)<br>      metadata              = optional(map(string))<br>    })))<br><br>    storage_fileshares = optional(map(object({<br>      quota       = number<br>      access_tier = optional(string)<br>    })))<br><br>    tags = optional(map(string))<br><br>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Default tags for all resource group | `string` | `null` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
