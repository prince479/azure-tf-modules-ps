# az_pgsql_flex

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_postgresql_firewall_rule.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_firewall_rule) | resource |
| [azurerm_postgresql_flexible_server.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server) | resource |
| [azurerm_postgresql_flexible_server_database.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_database) | resource |
| [random_password.admin_pass](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_postgres_flex_servers"></a> [postgres\_flex\_servers](#input\_postgres\_flex\_servers) | n/a | <pre>map(object({<br>    resource_group_name = string<br>    location            = string<br>    zone                = optional(string)<br><br>    delegated_subnet_id = optional(string)<br>    private_dns_zone_id = optional(string)<br><br>    administrator_login        = optional(string)<br>    administrator_password     = optional(string)<br>    administrator_gen_password = optional(bool)<br><br>    version     = optional(string)<br>    storage_mb  = optional(number)<br>    sku_name    = optional(string)<br>    create_mode = optional(string)<br><br>    backup_retention_days             = optional(number)<br>    point_in_time_restore_time_in_utc = optional(string)<br>    geo_redundant_backup_enabled      = optional(bool)<br><br>    high_availability = optional(object({<br>      mode                      = string<br>      standby_availability_zone = optional(number)<br>    }))<br><br>    maintenance_window = optional(object({<br>      day_of_week  = optional(number)<br>      start_hour   = optional(number)<br>      start_minute = optional(number)<br>    }))<br><br>    databases = optional(map(object({<br>      collation = optional(string)<br>      charset   = optional(string)<br>    })))<br><br>    firewall_rules = optional(map(object({<br>      start_ip_address = string<br>      end_ip_address   = string<br>    })))<br><br>    tags = map(string)<br>  }))</pre> | `{}` | no |
| <a name="input_psql_administrator_password"></a> [psql\_administrator\_password](#input\_psql\_administrator\_password) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_pgsql_db_result"></a> [pgsql\_db\_result](#output\_pgsql\_db\_result) | n/a |
| <a name="output_pgsql_server_result"></a> [pgsql\_server\_result](#output\_pgsql\_server\_result) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
