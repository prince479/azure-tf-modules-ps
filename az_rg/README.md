# az_rg

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
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default tags for all resource group | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | Default location for all resource group | `string` | `null` | no |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | Map Resource group you can override location and tag in maping | <pre>map(object({<br>    location = optional(string)<br>    tags     = optional(map(string))<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_group_result"></a> [resource\_group\_result](#output\_resource\_group\_result) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
