# az_mng_lock

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
| [azurerm_management_lock.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_az_manage_locks"></a> [az\_manage\_locks](#input\_az\_manage\_locks) | n/a | <pre>map(object({<br>    #Name is the key<br><br>    #Changing this forces a new resource to be created.<br>    scope = string<br><br>    #Possible values are CanNotDelete and ReadOnly. Changing this forces a new resource to be created.<br>    lock_level = string<br><br>    notes = optional(string)<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_az_manage_locks_result"></a> [az\_manage\_locks\_result](#output\_az\_manage\_locks\_result) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
