# output "private_endpoint_result" {
#   value = azurerm_private_endpoint.private_endpoint_001
# }

# Debug only
output "all_dns_zone_result" {
  value = data.azurerm_private_dns_zone.dns_zone_data
}

# Debug only
output "all_subnet_result" {
  value = data.azurerm_subnet.subnet_data
}

output "all_private_endpoint" {
  value = azurerm_private_endpoint.main
}
