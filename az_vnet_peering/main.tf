resource "azurerm_virtual_network_peering" "main" {
  for_each = var.vnet_peers

  resource_group_name = each.value.resource_group_name
  name                = each.key

  virtual_network_name = each.value.virtual_network_name
  remote_virtual_network_id = (each.value.remote_virtual_network_id != null ? each.value.remote_virtual_network_id :
  [for k, v in data.azurerm_virtual_network.data_vnet : v.id if v.name == each.value.remote_virtual_network_name][0])

  allow_virtual_network_access = each.value.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.allow_forwarded_traffic
  allow_gateway_transit        = each.value.allow_gateway_transit
  use_remote_gateways          = each.value.use_remote_gateways
}


data "azurerm_virtual_network" "data_vnet" {
  for_each = { for k, v in var.vnet_peers : k => v if v.remote_virtual_network_name != null && v.remote_virtual_network_resource_group_name != null }

  name                = each.value.remote_virtual_network_name
  resource_group_name = each.value.remote_virtual_network_resource_group_name
}
