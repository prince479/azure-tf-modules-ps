# az_vnet

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
| [azurerm_virtual_network.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_az_vnets"></a> [az\_vnets](#input\_az\_vnets) | n/a | <pre>map(object({<br>    address_spaces      = set(string)<br>    resource_group_name = optional(string)<br>    location            = optional(string)<br>    tags                = optional(map(string))<br>  }))</pre> | n/a | yes |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default Tags | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | Default Location | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Default Resource Group | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vnet_result"></a> [vnet\_result](#output\_vnet\_result) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
