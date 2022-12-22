
output "application_security_group_result" {
  value = azurerm_application_security_group.az_asg_resources
}

output "network_security_group_result" {
  value = azurerm_network_security_group.az_nsg_resources
}

# output "all_subnet_assoc_map_result" {
#   value = local.all_subnet_assoc_map
# }
