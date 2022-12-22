# Azure Private DNS Zone module

In vnet_link_names scope, if you define a virtual_network_id, the key as name and resource group will be ignored.

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
| [azurerm_private_dns_a_record.a_records_main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_cname_record.cname_records_main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_cname_record) | resource |
| [azurerm_private_dns_zone.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.vnet_network_links](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_virtual_network.vnet_data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default Tags | `map(string)` | `{}` | no |
| <a name="input_private_dns_zones"></a> [private\_dns\_zones](#input\_private\_dns\_zones) | n/a | <pre>map(object({<br>    resource_group_name = string<br>    tags                = map(string)<br><br>    vnet_link_names = map(object({<br>      registration_enabled = optional(bool)<br>      resource_group_name  = optional(string)<br>      virtual_network_id   = optional(string)<br>      inherit_tags         = optional(bool) #inherit tags from private dns zones<br>      tags                 = optional(map(string))<br>    }))<br><br>    soa_record = optional(object({<br>      email        = string<br>      expire_time  = optional(number)<br>      minimum_ttl  = optional(number)<br>      refresh_time = optional(number)<br>      retry_time   = optional(number)<br>      ttl          = optional(number)<br>    }))<br><br>    a_records = optional(map(object({<br>      ttl     = number<br>      records = set(string)<br>    })))<br><br>    cname_records = optional(map(object({<br>      ttl    = number<br>      record = string<br>    })))<br><br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_dns_zone_a_record_result"></a> [private\_dns\_zone\_a\_record\_result](#output\_private\_dns\_zone\_a\_record\_result) | n/a |
| <a name="output_private_dns_zone_result"></a> [private\_dns\_zone\_result](#output\_private\_dns\_zone\_result) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
