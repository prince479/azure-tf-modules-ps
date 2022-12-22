# az_vnet_peering

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
| [azurerm_virtual_network_peering.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |
| [azurerm_virtual_network.data_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vnet_peers"></a> [vnet\_peers](#input\_vnet\_peers) | n/a | <pre>map(object({<br>    resource_group_name  = string<br>    virtual_network_name = string<br><br>    remote_virtual_network_name                = optional(string)<br>    remote_virtual_network_resource_group_name = optional(string)<br>    remote_virtual_network_id                  = optional(string)<br><br>    allow_virtual_network_access = optional(bool)<br>    allow_forwarded_traffic      = optional(bool)<br>    allow_gateway_transit        = optional(bool)<br>    use_remote_gateways          = optional(bool)<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_remote_vnet_ds_result"></a> [remote\_vnet\_ds\_result](#output\_remote\_vnet\_ds\_result) | n/a |
| <a name="output_vnet_peering_result"></a> [vnet\_peering\_result](#output\_vnet\_peering\_result) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
