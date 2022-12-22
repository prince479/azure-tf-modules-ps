# az_appi

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
| [azurerm_application_insights.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_log_analytics_workspace.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_insights"></a> [app\_insights](#input\_app\_insights) | n/a | <pre>map(object({<br>    resource_group_name = optional(string)<br>    location            = optional(string)<br><br>    #Specifies the type of Application Insights to create. Valid values are <br>    #ios for iOS, <br>    #java for Java web, <br>    #MobileCenter for App Center, <br>    #Node.JS for Node.js, <br>    #other for General, <br>    #phone for Windows Phone, <br>    #store for Windows Store and <br>    #web for ASP.NET. <br>    #Please note these values are case sensitive; unmatched values are treated as ASP.NET by Azure. Changing this forces a new resource to be created.<br>    application_type = string<br><br>    daily_data_cap_in_gb = optional(number)<br><br>    #Specifies if a notification email will be send when the daily data volume cap is met.<br>    daily_data_cap_notifications_disabled = optional(string)<br><br>    retention_in_days                   = optional(number)<br>    sampling_percentage                 = optional(number)<br>    disable_ip_masking                  = optional(bool)<br>    local_authentication_disabled       = optional(bool)<br>    internet_ingestion_enabled          = optional(bool)<br>    internet_query_enabled              = optional(bool)<br>    force_customer_storage_for_profiler = optional(bool)<br><br>    # if you specify this, 'log_analytics_workspace' will be ignored<br>    workspace_id = optional(string)<br><br>    # Specify this if you want to create log workspace.<br>    log_analytics_workspace = optional(map(object({<br>      # Name is the key<br><br>      #Log Analytics Workspace. Possible values are <br>      #Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018 (new SKU as of 2018-04-03). Defaults to PerGB2018.<br>      sku               = optional(string)<br>      retention_in_days = number<br>    })))<br><br>    tags = map(string)<br>  }))</pre> | n/a | yes |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_insight_result"></a> [app\_insight\_result](#output\_app\_insight\_result) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
