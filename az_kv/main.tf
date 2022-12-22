locals {
  #   all_tenant = flatten([
  #     for k_kv, v_kv in var.key_vaults : [
  #       {
  #         key_vault_name = k_kv
  #         tenant_name    = v_kv.v_kv
  #       }
  #     ]
  #   ])
  #   all_tenant_map = { for k, v in local.all_tenant : k => v }

  all_access_policy = flatten([
    for k_kv, v_kv in var.key_vaults : v_kv.access_policies == null ? [] : [
      for k_policy, v_policy in v_kv.access_policies : [
        k_policy == "current" ?
        {
          kv_name = k_kv
          policy = {
            object_id      = data.azurerm_client_config.current.object_id
            application_id = v_policy.application_id

            certificate_permissions = v_policy.certificate_permissions
            key_permissions         = v_policy.key_permissions
            secret_permissions      = v_policy.secret_permissions
            storage_permissions     = v_policy.storage_permissions
          }
        } :
        {
          kv_name = k_kv
          policy  = v_policy
        }
  ]]])
  all_access_policy_map = { for k, v in local.all_access_policy : k => v }

  all_role_assignments = merge([
    for k_vault, v_vault in var.key_vaults : {
      for k_r_assign, v_r_assign in v_vault.role_assignments : "${k_r_assign}-${k_vault}" => v_r_assign
    } if v_vault.role_assignments != null
  ]...)
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  for_each = var.key_vaults == null ? {} : var.key_vaults

  resource_group_name = each.value.resource_group_name == null ? var.resource_group_name : each.value.resource_group_name
  location            = each.value.location == null ? var.location : each.value.location
  name                = each.key

  tenant_id = data.azurerm_client_config.current.tenant_id

  soft_delete_retention_days = each.value.soft_delete_retention_days
  purge_protection_enabled   = each.value.purge_protection_enabled

  sku_name = each.value.sku_name

  enabled_for_deployment          = each.value.enabled_for_deployment
  enabled_for_disk_encryption     = each.value.enabled_for_disk_encryption
  enabled_for_template_deployment = each.value.enabled_for_template_deployment
  enable_rbac_authorization       = each.value.enable_rbac_authorization

  dynamic "access_policy" {
    for_each = { for k, v in local.all_access_policy_map : k => v if each.key == v.kv_name }

    content {
      tenant_id      = data.azurerm_client_config.current.tenant_id
      object_id      = access_policy.value.policy.object_id
      application_id = access_policy.value.policy.application_id

      certificate_permissions = access_policy.value.policy.certificate_permissions
      key_permissions         = access_policy.value.policy.key_permissions
      secret_permissions      = access_policy.value.policy.secret_permissions
      storage_permissions     = access_policy.value.policy.storage_permissions
    }
  }

  dynamic "contact" {
    for_each = each.value.contacts == null ? {} : each.value.contacts
    content {
      name  = contact.key
      email = contact.value.email
      phone = contact.value.phone
    }
  }

  tags = merge(var.default_tags, each.value.tags)
}

resource "azurerm_key_vault_key" "generated_keys" {
  for_each = var.generated_keys == null ? {} : var.generated_keys

  key_vault_id = each.value.key_vault_id
  name         = each.key
  key_type     = each.value.key_type
  key_size     = each.value.key_size
  curve        = each.value.curve

  not_before_date = each.value.not_before_date
  expiration_date = each.value.expiration_date

  key_opts = each.value.key_opts

  tags = merge(var.default_tags, each.value.tags)

  depends_on = [
    azurerm_key_vault.main
  ]

}

data "azurerm_user_assigned_identity" "user_id_for_role_assign" {
  for_each = { for k, v in local.all_role_assignments : k => v if v.managed_user_identity_name != null }

  name                = each.value.managed_user_identity_name
  resource_group_name = each.value.managed_user_identity_resource_group_name
}

resource "azurerm_role_assignment" "main" {
  for_each = local.all_role_assignments

  scope                = [for k, v in azurerm_key_vault.main : v.id if length(regexall(".*-${k}", each.key)) > 0][0]
  principal_id         = [for k, v in data.azurerm_user_assigned_identity.user_id_for_role_assign : v.principal_id if k == each.key][0]
  role_definition_id   = each.value.role_definition_id
  role_definition_name = each.value.role_definition_name

  condition         = each.value.condition
  condition_version = each.value.condition_version

  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  description                            = each.value.description
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check

  depends_on = [
    azurerm_key_vault.main
  ]
}
