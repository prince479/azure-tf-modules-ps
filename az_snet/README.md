# az_snet

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
| [azurerm_subnet.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Default ressource group name | `string` | `null` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | n/a | <pre>map(object({<br>    virtual_network_name = optional(string)<br>    resource_group_name  = optional(string)<br>    subnet_prefix        = list(string)<br>    service_endpoints    = optional(list(string))<br><br>    enforce_private_link_endpoint_network_policies = optional(bool)<br>    enforce_private_link_service_network_policies  = optional(bool)<br><br>    delegation = optional(object({<br>      name = string<br>      service_delegation = object({<br>        name    = string<br>        actions = list(string)<br>      })<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | Default virtual network name | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_snet_result"></a> [snet\_result](#output\_snet\_result) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
