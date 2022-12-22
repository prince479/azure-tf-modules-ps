output "vnet_peering_result" {
  value = azurerm_virtual_network_peering.main
}

output "remote_vnet_ds_result" {
  value = data.azurerm_virtual_network.data_vnet
}
