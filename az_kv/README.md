# az_kv

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
| [azurerm_key_vault.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_key.generated_keys](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_role_assignment.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_user_assigned_identity.user_id_for_role_assign](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default Tags | `map(string)` | `{}` | no |
| <a name="input_generated_keys"></a> [generated\_keys](#input\_generated\_keys) | n/a | <pre>map(object({<br>    key_vault_id = string<br>    key_type     = string<br>    key_size     = optional(number)<br>    curve        = optional(string)<br><br>    not_before_date = optional(string)<br><br>    # Notic: Expiration UTC datetime (Y-m-d'T'H:M:S'Z')<br>    expiration_date = optional(string)<br><br>    tags = map(string)<br><br>    key_opts = optional(set(string))<br>  }))</pre> | `{}` | no |
| <a name="input_key_vaults"></a> [key\_vaults](#input\_key\_vaults) | n/a | <pre>map(object({<br><br>    resource_group_name = optional(string)<br>    location            = optional(string)<br><br>    tenant_name = optional(string)<br><br>    soft_delete_retention_days = optional(number)<br>    purge_protection_enabled   = optional(bool)<br><br>    sku_name = string<br><br>    access_policy = optional(map(object({<br>      tenant_name = string<br>      object_name = string<br>    })))<br><br>    enabled_for_deployment          = optional(bool)<br>    enabled_for_disk_encryption     = optional(bool)<br>    enabled_for_template_deployment = optional(bool)<br>    enable_rbac_authorization       = optional(bool)<br><br>    access_policies = optional(map(object({<br>      object_id      = string<br>      application_id = optional(string)<br><br>      certificate_permissions = optional(set(string))<br>      key_permissions         = optional(set(string))<br>      secret_permissions      = optional(set(string))<br>      storage_permissions     = optional(set(string))<br>    })))<br><br>    role_assignments = optional(map(object({<br>      role_definition_id   = optional(string)<br>      role_definition_name = optional(string)<br><br>      managed_user_identity_name                = optional(string)<br>      managed_user_identity_resource_group_name = optional(string)<br><br>      condition         = optional(string)<br>      condition_version = optional(string)<br><br>      delegated_managed_identity_resource_id = optional(string)<br>      description                            = optional(string)<br>      skip_service_principal_aad_check       = optional(bool)<br>    })))<br><br>    contacts = optional(map(object({<br>      email = string<br>      phone = optional(string)<br>    })))<br><br>    tags = map(string)<br>  }))</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Default Location | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Default Resource Group | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_all_access_policy_result"></a> [all\_access\_policy\_result](#output\_all\_access\_policy\_result) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
