
# Debug only
# output "all_high_availability_map_result" {
#   value = local.all_high_availability_map
# }

# Debug only
# output "all_maintenance_window_map_result" {
#   value = local.all_maintenance_window_map
# }

output "pgsql_server_result" {
  value = azurerm_postgresql_flexible_server.main
}

output "pgsql_db_result" {
  value = azurerm_postgresql_flexible_server_database.main
}
