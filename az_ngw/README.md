# az_ngw

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
| [azurerm_nat_gateway.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway) | resource |
| [azurerm_nat_gateway_public_ip_association.ngw_pip_assoc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway_public_ip_association) | resource |
| [azurerm_nat_gateway_public_ip_prefix_association.ngw_ippre_assoc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway_public_ip_prefix_association) | resource |
| [azurerm_public_ip.pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip_prefix.ippre](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip_prefix) | resource |
| [azurerm_subnet_nat_gateway_association.ngw_assoc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_nat_gateways"></a> [nat\_gateways](#input\_nat\_gateways) | n/a | <pre>map(object({<br>    resource_group_name = string<br>    location            = string<br><br>    sku_name         = optional(string)<br>    zones            = optional(list(string))<br>    ip_prefix_length = number<br><br>    associated_subnets = set(string)<br><br>    auto_create_public_ip = optional(bool)<br>    public_ip_spec = optional(object({<br>      name                = optional(string)<br>      resource_group_name = optional(string)<br>      allocation_method   = optional(string)<br>      sku                 = optional(string)<br>      tags                = optional(map(string))<br>    }))<br><br>    tags = map(string)<br>    })<br>  )</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nat_gateway_result"></a> [nat\_gateway\_result](#output\_nat\_gateway\_result) | n/a |
| <a name="output_nat_public_ip_result"></a> [nat\_public\_ip\_result](#output\_nat\_public\_ip\_result) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
