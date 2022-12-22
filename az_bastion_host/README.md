# az_bastion_host

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_bastion_host.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/bastion_host) | resource |
| [azurerm_public_ip.pip_prep](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_subnet.bas_target_subnet_data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastion_hosts"></a> [bastion\_hosts](#input\_bastion\_hosts) | n/a | <pre>map(object({<br>    resource_group_name = string<br>    location            = string<br>    sku                 = string<br>    tunneling_enabled   = optional(bool) #only supported when sku is Standard<br><br>    copy_paste_enabled     = optional(bool)<br>    file_copy_enabled      = optional(bool)   #only supported when sku is Standard<br>    ip_connect_enabled     = optional(bool)   #only supported when sku is Standard<br>    scale_units            = optional(number) #only can be changed when sku is Standard.<br>    shareable_link_enabled = optional(bool)   #only supported when sku is Standard<br><br>    ip_configuration = object({<br>      vnet_name = string<br>    })<br>    tags = optional(map(string))<br>  }))</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_host_result"></a> [bastion\_host\_result](#output\_bastion\_host\_result) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
