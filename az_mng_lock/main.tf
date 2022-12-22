resource "azurerm_management_lock" "main" {
  for_each = var.az_manage_locks

  name       = each.key
  scope      = each.value.scope
  lock_level = each.value.lock_level
  notes      = each.value.notes
}
