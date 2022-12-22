resource "azurerm_user_assigned_identity" "main" {
  for_each = var.az_user_assigned_ids

  resource_group_name = each.value.resource_group_name == null ? var.resource_group_name : each.value.resource_group_name
  location            = each.value.location == null ? var.location : each.value.location
  name                = each.key

  tags = merge(var.default_tags, each.value.tags)
}
