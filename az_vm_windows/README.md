# az_vm_linux

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
| [azurerm_network_interface.vm_interfaces](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_public_ip.pip_prep](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_windows_virtual_machine.vm_windows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |
| [azurerm_subnet.data_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_az_vm_windows"></a> [az\_vm\_windows](#input\_az\_vm\_windows) | n/a | <pre>map(object({<br>    computer_name        = optional(string)<br>    size                 = string<br>    admin_username       = string<br>    admin_password       = optional(string)<br>    custom_data          = optional(string)<br>    custom_data_fromfile = optional(string)<br>    user_data            = optional(string)<br>    user_data_fromfile   = optional(string)<br>    priority             = optional(string)<br>    eviction_policy      = optional(string)<br><br>    os_disk = object({<br>      caching                = string<br>      storage_account_type   = string<br>      disk_size_gb           = optional(number)<br>      disk_encryption_set_id = optional(string)<br>    })<br><br>    source_image_reference = optional(object({<br>      publisher = string<br>      offer     = string<br>      sku       = string<br>      version   = string<br>    }))<br>    source_image_id = optional(string)<br><br>    network_interfaces = map(object({<br>      name                          = optional(string) # Override name<br>      enable_accelerated_networking = optional(bool)<br>      enable_public_ip              = optional(bool) # default: false<br>      public_ip_allocation_method   = optional(string)<br>      resource_group_name           = optional(string)<br><br>      ip_configuration = object({<br>        name                          = string<br>        vnet_name                     = optional(string)<br>        subnet_name                   = optional(string)<br>        vnet_resource_group_name      = optional(string)<br>        private_ip_address_allocation = optional(string)<br>        public_ip_address_id          = optional(string)<br>        private_ip_address            = optional(string)<br>        subnet_id                     = optional(string)<br>      })<br>    }))<br><br>    tags = optional(map(string))<br><br>  }))</pre> | n/a | yes |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_windows_admin_password"></a> [windows\_admin\_password](#input\_windows\_admin\_password) | n/a | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_all_instance_result"></a> [all\_instance\_result](#output\_all\_instance\_result) | n/a |
| <a name="output_all_subnet_data_result"></a> [all\_subnet\_data\_result](#output\_all\_subnet\_data\_result) | n/a |
| <a name="output_all_subnet_name_result"></a> [all\_subnet\_name\_result](#output\_all\_subnet\_name\_result) | n/a |
| <a name="output_network_interfaces_result"></a> [network\_interfaces\_result](#output\_network\_interfaces\_result) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
