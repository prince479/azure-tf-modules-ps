# az_rt

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
| [azurerm_route_table.route_table_001](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_subnet_route_table_association.rt_assoc_001](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_subnet.rt_assoc_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default Tags | `map(string)` | `{}` | no |
| <a name="input_route_tables"></a> [route\_tables](#input\_route\_tables) | n/a | <pre>map(object({<br>    resource_group_name = string<br>    location            = string<br><br>    subnet_names_association = optional(map(object({<br>      vnet_name           = string<br>      resource_group_name = string<br>    })))<br><br>    routes = optional(map(object({<br>      address_prefix         = string<br>      next_hop_type          = string<br>      next_hop_in_ip_address = string<br>    })))<br><br>    tags = map(string)<br><br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_route_table_result"></a> [route\_table\_result](#output\_route\_table\_result) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
