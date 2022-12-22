
resource "azurerm_virtual_network" "main" {
  for_each = var.az_vnets

  address_space       = each.value.address_spaces
  name                = each.key
  location            = each.value.location == null ? var.location : each.value.location
  resource_group_name = each.value.resource_group_name == null ? var.resource_group_name : each.value.resource_group_name


  tags = merge(var.default_tags, each.value.tags)
}
