# az_sg_ag

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
| [azurerm_application_security_group.az_asg_resources](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_security_group) | resource |
| [azurerm_network_security_group.az_nsg_resources](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_subnet_network_security_group_association.nsg_assoc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_security_groups"></a> [application\_security\_groups](#input\_application\_security\_groups) | n/a | <pre>map(object({<br>    location            = optional(string)<br>    resource_group_name = optional(string)<br><br>    tags = map(string)<br><br>  }))</pre> | n/a | yes |
| <a name="input_default_location"></a> [default\_location](#input\_default\_location) | n/a | `string` | `null` | no |
| <a name="input_default_resource_group_name"></a> [default\_resource\_group\_name](#input\_default\_resource\_group\_name) | n/a | `string` | `null` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_network_security_groups"></a> [network\_security\_groups](#input\_network\_security\_groups) | n/a | <pre>map(object({<br>    resource_group_name = optional(string)<br>    location            = optional(string)<br><br>    security_rules = map(object({<br>      priority                   = number<br>      direction                  = string<br>      access                     = string<br>      protocol                   = string<br>      source_port_range          = string<br>      destination_port_range     = string<br>      source_address_prefix      = string<br>      destination_address_prefix = string<br>      }<br>    ))<br><br>    subnet_association_ids = optional(set(string))<br><br>    tags = map(string)<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_security_group_result"></a> [application\_security\_group\_result](#output\_application\_security\_group\_result) | n/a |
| <a name="output_network_security_group_result"></a> [network\_security\_group\_result](#output\_network\_security\_group\_result) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
