# util_appsetting_prep

This module is used for prepare app_settings and sticky_settings. It will merge between individual app setting and default app setting into each app service oject.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_services"></a> [app\_services](#input\_app\_services) | n/a | `any` | n/a | yes |
| <a name="input_default_app_settings"></a> [default\_app\_settings](#input\_default\_app\_settings) | n/a | `map(string)` | `{}` | no |
| <a name="input_default_sticky_settings"></a> [default\_sticky\_settings](#input\_default\_sticky\_settings) | n/a | <pre>object({<br>    app_setting_names       = optional(set(string))<br>    connection_string_names = optional(set(string))<br>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_services_result"></a> [app\_services\_result](#output\_app\_services\_result) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
