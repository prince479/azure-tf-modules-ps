output "linux_vmss_results" {
  value     = azurerm_linux_virtual_machine_scale_set.main
  sensitive = true
}
