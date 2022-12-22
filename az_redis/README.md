# az_redis

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
| [azurerm_redis_cache.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_cache) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_az_redis"></a> [az\_redis](#input\_az\_redis) | n/a | <pre>map(object({<br>    location                      = string<br>    resource_group_name           = string<br>    capacity                      = number #The size of the Redis cache to deploy. Valid values for a SKU family of C (Basic/Standard) are 0, 1, 2, 3, 4, 5, 6, and for P (Premium) family are 1, 2, 3, 4.<br>    family                        = string # The SKU family/pricing group to use. Valid values are C (for Basic/Standard SKU family) and P (for Premium)<br>    sku_name                      = string #Possible values are Basic, Standard and Premium.<br>    enable_non_ssl_port           = optional(bool)<br>    minimum_tls_version           = optional(string)<br>    private_static_ip_address     = optional(string)<br>    public_network_access_enabled = optional(bool)<br>    replicas_per_master           = optional(number)<br>    replicas_per_primary          = optional(number)<br>    redis_version                 = optional(number)<br>    tenant_settings               = optional(map(string))<br>    shard_count                   = optional(number)<br>    subnet_id                     = optional(string)<br>    subnet_name                   = optional(string)<br>    tags                          = optional(map(string))<br>    zones                         = optional(set(string))<br><br>    redis_configuration = optional(object({<br>      aof_backup_enabled              = optional(bool)<br>      aof_storage_connection_string_0 = optional(string)<br>      aof_storage_connection_string_1 = optional(string)<br>      enable_authentication           = optional(bool)<br>      maxmemory_reserved              = optional(number)<br>      maxmemory_delta                 = optional(number)<br>      maxmemory_policy                = optional(number)<br>      maxfragmentationmemory_reserved = optional(number)<br>      rdb_backup_enabled              = optional(bool)<br>      rdb_backup_frequency            = optional(number)<br>      rdb_backup_max_snapshot_count   = optional(number)<br>      rdb_storage_connection_string   = optional(string)<br>      notify_keyspace_events          = optional(set(string))<br>    }))<br><br>    patch_schedule = optional(map(object({<br>      day_of_week        = string<br>      start_hour_utc     = optional(number)<br>      maintenance_window = optional(string)<br>    })))<br>  }))</pre> | n/a | yes |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | n/a | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
