output "network_interfaces_result" {
  value = azurerm_network_interface.vm_interfaces
}
output "all_subnet_name_result" {
  value = local.all_subnet_name
}

output "all_subnet_data_result" {
  value = data.azurerm_subnet.data_subnet
}

output "all_instance_result" {
  value     = azurerm_linux_virtual_machine.vm_linux
  sensitive = true
}
