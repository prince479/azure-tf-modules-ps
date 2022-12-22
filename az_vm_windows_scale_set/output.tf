output "windows_vmss_results" {
  value     = azurerm_windows_virtual_machine_scale_set.main
  sensitive = true
}
