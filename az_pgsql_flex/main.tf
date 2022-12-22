
locals {
  all_db_name = merge([
    for k_pgsql_sv, v_pgsql_sv in var.postgres_flex_servers : {
      for k_db, v_db in v_pgsql_sv.databases : "${k_db}-${k_pgsql_sv}" => merge(v_db, {
        db_name        = k_db,
        db_server_name = k_pgsql_sv
      })
    } if v_pgsql_sv.databases != null
  ]...)

  all_firewall_rules = merge([
    for k_pgsql_sv, v_pgsql_sv in var.postgres_flex_servers : {
      for k_rule, v_rule in v_pgsql_sv.firewall_rules : "${k_rule}-${k_pgsql_sv}" => merge(v_rule, {
        rule_name                     = k_rule,
        db_server_name                = k_pgsql_sv,
        db_server_resource_group_name = v_pgsql_sv.resource_group_name
      })
    } if v_pgsql_sv.firewall_rules != null
  ]...)

  to_gen_pass = merge({
    for k_pgsql_sv, v_pgsql_sv in var.postgres_flex_servers :
    k_pgsql_sv => v_pgsql_sv
  if try(v_pgsql_sv.administrator_gen_password == true, false) })

}

resource "random_password" "admin_pass" {
  for_each = local.to_gen_pass

  length  = 16
  special = true
}

resource "azurerm_postgresql_flexible_server" "main" {
  for_each = var.postgres_flex_servers

  name                = each.key
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  zone                = each.value.zone

  delegated_subnet_id = each.value.delegated_subnet_id
  private_dns_zone_id = each.value.private_dns_zone_id
  create_mode = each.value.create_mode
  
#   create_mode                       = try(var.settings.create_mode, "Default")
#   point_in_time_restore_time_in_utc = try(var.settings.create_mode, "PointInTimeRestore") == "PointInTimeRestore" ? try(var.settings.point_in_time_restore_time_in_utc, null) : null
#   source_server_id                  = try(var.settings.create_mode, "PointInTimeRestore") == "PointInTimeRestore" ? try(var.settings.source_server_id, null) : null

  administrator_login = each.value.administrator_login
  administrator_password = (try(each.value.administrator_gen_password == true, false) ? lookup(random_password.admin_pass, each.key).result :
  each.value.administrator_password != null ? each.value.administrator_password : var.psql_administrator_password)


  version     = each.value.version
  storage_mb  = each.value.storage_mb
  sku_name    = each.value.sku_name
 
  backup_retention_days        = each.value.backup_retention_days
  geo_redundant_backup_enabled = each.value.geo_redundant_backup_enabled

  dynamic "high_availability" {
    #for_each = { for k, v in local.all_high_availability_map : k => v if each.key == v.db_name }
    for_each = each.value.high_availability == null ? [] : [each.value.high_availability]
    content {
      mode                      = high_availability.value.mode
      standby_availability_zone = high_availability.value.standby_availability_zone
    }
  }

  dynamic "maintenance_window" {
    # for_each = { for k, v in local.all_maintenance_window_map : k => v if each.key == v.db_name }
    for_each = each.value.maintenance_window == null ? [] : [each.value.maintenance_window]
    content {
      day_of_week  = maintenance_window.value.day_of_week
      start_hour   = maintenance_window.value.start_hour
      start_minute = maintenance_window.value.start_minute
    }
  }


  tags = merge(var.default_tags, each.value.tags)
}
    
  resource "time_sleep" "server_configuration" {
  depends_on = [azurerm_postgresql_flexible_server.main]

  create_duration  = "120s"
  destroy_duration = "300s"
}

resource "azurerm_postgresql_flexible_server_configuration" "postgresql" {
  depends_on = [time_sleep.server_configuration]
  for_each   = try(var.settings.postgresql_configurations, {})

  name      = each.value.name
  server_id = azurerm_postgresql_flexible_server.postgresql.id
  value     = each.value.value
}

resource "azurerm_postgresql_flexible_server_database" "main" {
  for_each = local.all_db_name

  name      = each.value.db_name
  server_id = [for k, v in azurerm_postgresql_flexible_server.main : v.id if k == each.value.db_server_name][0]
  collation = each.value.collation
  charset   = each.value.charset
}

resource "azurerm_postgresql_firewall_rule" "main" {
  for_each = local.all_firewall_rules

  name                = each.value.rule_name
  server_name         = each.value.db_server_name
  resource_group_name = each.value.resource_group_name
  start_ip_address    = each.value.start_ip_address
  end_ip_address      = each.value.end_ip_address
}
