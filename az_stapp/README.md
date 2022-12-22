# az_stapp

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
| [azurerm_static_site.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/static_site) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_az_static_web_apps"></a> [az\_static\_web\_apps](#input\_az\_static\_web\_apps) | n/a | <pre>map(object({<br>    resource_group_name = optional(string)<br>    location            = optional(string)<br>    sku_tier            = optional(string)<br>    sku_size            = optional(string)<br>    tags                = optional(string)<br>    identity = optional(object({<br>      type         = string<br>      identity_ids = set(string)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | Default Resource Group | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Default Resource Group | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_az_static_web_app_result"></a> [az\_static\_web\_app\_result](#output\_az\_static\_web\_app\_result) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
