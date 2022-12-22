# az_pe

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
| [azurerm_private_endpoint.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_dns_zone.dns_zone_data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_subnet.subnet_data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_private_endpoint_resource_group"></a> [private\_endpoint\_resource\_group](#input\_private\_endpoint\_resource\_group) | Apply the resource group to all pe if they are not provide individually. (This var is not implement.) | `string` | `null` | no |
| <a name="input_private_endpoints"></a> [private\_endpoints](#input\_private\_endpoints) | n/a | <pre>map(object({<br>    resource_group_name      = string<br>    location                 = string<br>    vnet_name                = string<br>    vnet_resource_group_name = optional(string)<br>    subnet_name              = string<br><br>    private_dns_zone_group = optional(object({<br>      name                                 = string<br>      private_dns_zone_names               = optional(set(string))<br>      private_dns_zone_resource_group_name = optional(string)<br>      private_dns_zone_ids                 = optional(set(string))<br>    }))<br><br>    private_service_connection = object({<br>      name                              = string<br>      is_manual_connection              = bool<br>      private_connection_resource_id    = optional(string)<br>      private_connection_resource_alias = optional(string)<br>      subresource_names                 = optional(set(string))<br>      request_message                   = optional(string)<br>    })<br><br>    tags = map(string)<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_all_dns_zone_result"></a> [all\_dns\_zone\_result](#output\_all\_dns\_zone\_result) | Debug only |
| <a name="output_all_private_endpoint"></a> [all\_private\_endpoint](#output\_all\_private\_endpoint) | n/a |
| <a name="output_all_subnet_result"></a> [all\_subnet\_result](#output\_all\_subnet\_result) | Debug only |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
