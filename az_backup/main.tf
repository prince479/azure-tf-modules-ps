resource "azurerm_recovery_services_vault" "vault" {
  for_each            = var.backup_vault
  name                = each.key
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = each.value.sku
  soft_delete_enabled = each.value.soft_delete_enabled
  storage_mode_type   = each.value.storage_mode_type
  tags                = var.default_tags          
}

resource "azurerm_backup_policy_vm" "policy" {
  for_each            = var.backup_vault
  name                = each.value.backup_policy_name
  resource_group_name = azurerm_recovery_services_vault.vault[each.key].resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.vault[each.key].name
  timezone            = each.value.timezone
  backup {
    frequency = each.value.backup_frequency
    time      = each.value.time
  }
  retention_daily {
    count = each.value.retention_daily
  }
}

