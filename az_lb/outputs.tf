output "lb_results" {
  value = azurerm_lb.main
}

output "lb_backend_pool_results" {
  value = azurerm_lb_backend_address_pool.main
}
