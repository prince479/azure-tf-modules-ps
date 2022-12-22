
resource "azurerm_subnet" "main" {
  for_each = var.subnets

  resource_group_name  = each.value.resource_group_name == null ? var.resource_group_name : each.value.resource_group_name
  name                 = each.key
  address_prefixes     = each.value.subnet_prefix
  virtual_network_name = each.value.virtual_network_name == null ? var.virtual_network_name : each.value.virtual_network_name
  service_endpoints    = each.value.service_endpoints

  enforce_private_link_endpoint_network_policies = each.value.enforce_private_link_endpoint_network_policies
  enforce_private_link_service_network_policies  = each.value.enforce_private_link_service_network_policies

  dynamic "delegation" {
    for_each = each.value.delegation == null ? [] : [each.value.delegation]
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
}
