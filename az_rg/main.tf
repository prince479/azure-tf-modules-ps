resource "azurerm_resource_group" "main" {
  for_each = var.resource_groups
  name     = each.key
  location = each.value.location == null ? var.location : each.value.location
  tags     = try(merge(var.default_tags, each.value.tags), each.value.tags)
}
