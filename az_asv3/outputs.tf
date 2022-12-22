# output "app_service_environment_result" {
#   value = azurerm_app_service_environment_v3.ase_v3_main
# }
 
output "app_plan_result" {
  value = azurerm_service_plan.app_plans_main
}

output "app_windows_services_result" {
  value = azurerm_windows_web_app.app_windows_main
  sensitive = true
}

output "app_plan_result_map" {
  value = { for plan in azurerm_service_plan.app_plans_main : plan.name => plan.id }
}

output "app_windows_services_result_map" {
  value = { for windows in azurerm_windows_web_app.app_windows_main : windows.name => windows.id }
}

output "app_windows_services_slot_result_map" {
  value = [ for windows in azurerm_windows_web_app_slot.main : windows]
}

# output "app_service_environment_v3_cluster_setting_check" {
#   value = local.app_service_environment_v3_cluster_setting
# }
