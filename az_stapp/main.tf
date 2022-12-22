resource "azurerm_static_site" "main" {
  for_each = var.az_static_web_apps

  name                = each.key
  resource_group_name = each.value.resource_group_name != null ? each.value.resource_group_name : var.resource_group_name
  location            = each.value.location != null ? each.value.location : var.location
  sku_tier            = each.value.sku_tier
  sku_size            = each.value.sku_size
  tags                = merge(var.default_tags, each.value.tags)

  dynamic "identity" {
    for_each = each.value.identity == null ? [] : [each.value.identity]

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
}
