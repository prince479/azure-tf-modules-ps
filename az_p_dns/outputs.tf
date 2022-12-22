output "private_dns_zone_result" {
  value = azurerm_private_dns_zone.main
}

output "private_dns_zone_a_record_result" {
  value = azurerm_private_dns_a_record.a_records_main
}

# For debuging
# output "soa_record_list_result" {
#   value = local.all_soa_record_map
# }

# For debuging
# output "all_vnet_name_result" {
#   value = local.all_vnet_name
# }
