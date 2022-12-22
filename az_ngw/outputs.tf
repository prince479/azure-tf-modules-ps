output "nat_gateway_result" {
  value = azurerm_nat_gateway.main
}

output "nat_public_ip_result" {
  value = azurerm_public_ip.pip
}
