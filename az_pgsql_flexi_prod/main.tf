locals{
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
  
  
  version     = each.value.version
  storage_mb  = each.value.storage_mb
  sku_name    = each.value.sku_name
  create_mode = each.value.create_mode
  
  
  delegated_subnet_id = each.value.delegated_subnet_id
  private_dns_zone_id = each.value.private_dns_zone_id
  administrator_login = each.value.administrator_login
  administrator_password = (try(each.value.administrator_gen_password == true, false) ? lookup(random_password.admin_pass, each.key).result :
  each.value.administrator_password != null ? each.value.administrator_password : var.psql_administrator_password)
  
  
  
  
  tags = merge(var.default_tags, each.value.tags)

}
