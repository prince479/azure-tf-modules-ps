# az_id

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
| [azurerm_user_assigned_identity.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_az_user_assigned_ids"></a> [az\_user\_assigned\_ids](#input\_az\_user\_assigned\_ids) | n/a | <pre>map(object({<br>    resource_group_name = optional(string)<br>    location            = optional(string)<br>    tags                = map(string)<br>  }))</pre> | n/a | yes |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default tags for all resource group | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | Default location for all resource group | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Default ressource group name | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_az_user_assigned_ids"></a> [az\_user\_assigned\_ids](#output\_az\_user\_assigned\_ids) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
