# az_vm_windows_scale_set

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
| [azurerm_windows_virtual_machine_scale_set.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine_scale_set) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_lb_backend_address_pool.data_bk_addr_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/lb_backend_address_pool) | data source |
| [azurerm_subnet.data_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_az_vm_windows_scale_set"></a> [az\_vm\_windows\_scale\_set](#input\_az\_vm\_windows\_scale\_set) | n/a | <pre>map(object({<br>    resource_group_name  = optional(string)<br>    location             = optional(string)<br>    computer_name_prefix = optional(string) # If vmss name is more than 9 chars, you need to provide prefix which is not exceed 9 chars<br>    admin_username       = string<br>    instances            = number<br>    sku                  = string<br><br>    custom_data          = optional(string)<br>    custom_data_fromfile = optional(string)<br>    user_data            = optional(string)<br>    user_data_fromfile   = optional(string)<br><br>    priority        = optional(string)<br>    eviction_policy = optional(string)<br><br>    zones        = optional(set(string))<br>    zone_balance = optional(bool)<br>    vtpm_enabled = optional(bool)<br><br>    #Possible values are Automatic, Manual and Rolling. Defaults to Manual.<br>    upgrade_mode = optional(string)<br><br>    additional_capabilities = optional(object({<br>      ultra_ssd_enabled = optional(string)<br>    }))<br><br>    os_disk = object({<br>      caching                = string<br>      storage_account_type   = string<br>      disk_size_gb           = optional(number)<br>      disk_encryption_set_id = optional(string)<br>    })<br><br>    source_image_reference = optional(object({<br>      publisher = string<br>      offer     = string<br>      sku       = string<br>      version   = string<br>    }))<br>    source_image_id = optional(string)<br><br>    rolling_upgrade_policy = optional(object({<br>      max_batch_instance_percent              = number<br>      max_unhealthy_instance_percent          = number<br>      max_unhealthy_upgraded_instance_percent = number<br>      pause_time_between_batches              = string<br>    }))<br><br>    network_interfaces = map(object({<br>      enable_accelerated_networking = optional(bool)<br>      network_security_group_id     = optional(string)<br>      primary                       = optional(bool)<br>      dns_servers                   = optional(set(string))<br>      enable_ip_forwarding          = optional(bool)<br><br>      ip_configuration = object({<br>        name                                         = string<br>        primary                                      = optional(bool)<br>        vnet_name                                    = optional(string)<br>        subnet_name                                  = optional(string)<br>        vnet_resource_group_name                     = optional(string)<br>        subnet_id                                    = optional(string)<br>        application_gateway_backend_address_pool_ids = optional(set(string))<br>        application_security_group_ids               = optional(set(string))<br><br>        # This block is used to find load_balancer_backend_address_pool data.<br>        # if provide load_balancer_backend_address_pool_ids, this block will be ignored.<br>        load_balancers = optional(map(object({<br>          load_balancer_resource_group_name        = string<br>          load_balancer_backend_address_pool_names = optional(set(string))<br>          load_balancer_inbound_nat_rules_names    = optional(set(string))<br>        })))<br><br>        load_balancer_backend_address_pool_ids = optional(set(string))<br>        load_balancer_inbound_nat_rules_ids    = optional(set(string))<br><br>        version = optional(string)<br>        public_ip_address = optional(object({<br>          name                    = string<br>          domain_name_label       = optional(string)<br>          idle_timeout_in_minutes = optional(number)<br><br>          # map name is the tag name<br>          ip_tag = optional(map(object({<br>            type = string<br>          })))<br><br>          public_ip_prefix_id = optional(string)<br>        }))<br>      })<br>    }))<br><br>    tags = optional(map(string))<br>  }))</pre> | n/a | yes |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_public_key_from_env"></a> [public\_key\_from\_env](#input\_public\_key\_from\_env) | n/a | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_windows_admin_password"></a> [windows\_admin\_password](#input\_windows\_admin\_password) | n/a | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_windows_vmss_results"></a> [windows\_vmss\_results](#output\_windows\_vmss\_results) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
