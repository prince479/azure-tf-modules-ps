
locals {
  all_subnet_map = try({
    for k_pe, v_pe in var.private_endpoints :
    "all-snet-${k_pe}-${v_pe.subnet_name}" => {
      resource_group_name = v_pe.vnet_resource_group_name != null ? v_pe.vnet_resource_group_name : v_pe.resource_group_name
      vnet_name           = v_pe.vnet_name
      subnet_name         = v_pe.subnet_name
  } }, {})

  all_private_dns_zone_map = merge(flatten([
    for k_pe, v_pe in var.private_endpoints : {
      for p_dns_zone in v_pe.private_dns_zone_group.private_dns_zone_names :
      "all-pri-${p_dns_zone}-${k_pe}" => {
        dns_zone_name = p_dns_zone
        resource_group_name = (v_pe.private_dns_zone_group.private_dns_zone_resource_group_name != null ?
        v_pe.private_dns_zone_group.private_dns_zone_resource_group_name : v_pe.resource_group_name)
        pe_name = k_pe
      }
    } if try(v_pe.private_dns_zone_group.private_dns_zone_names != null && v_pe.private_dns_zone_group.private_dns_zone_names != [], false)
  ])...)
}

data "azurerm_subnet" "subnet_data" {
  for_each = local.all_subnet_map

  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.vnet_name
  name                 = each.value.subnet_name
}

data "azurerm_private_dns_zone" "dns_zone_data" {
  for_each = local.all_private_dns_zone_map

  resource_group_name = each.value.resource_group_name
  name                = each.value.dns_zone_name
}

resource "azurerm_private_endpoint" "main" {
  for_each = var.private_endpoints

  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  name                = each.key

  subnet_id = [for k, v in data.azurerm_subnet.subnet_data : v.id if v.virtual_network_name == each.value.vnet_name && v.name == each.value.subnet_name][0]

  dynamic "private_dns_zone_group" {
    for_each = each.value.private_dns_zone_group == null ? [] : [each.value.private_dns_zone_group]
    content {
      name = private_dns_zone_group.value.name
      private_dns_zone_ids = (private_dns_zone_group.value.private_dns_zone_ids != null ? private_dns_zone_group.value.private_dns_zone_ids :
      distinct([for k, v in data.azurerm_private_dns_zone.dns_zone_data : v.id if contains(private_dns_zone_group.value.private_dns_zone_names, v.name)]))
    }
  }
  private_service_connection {
    name                              = "${each.key}-${each.value.private_service_connection.name}"
    is_manual_connection              = each.value.private_service_connection.is_manual_connection
    private_connection_resource_id    = each.value.private_service_connection.private_connection_resource_id
    subresource_names                 = each.value.private_service_connection.subresource_names
    private_connection_resource_alias = each.value.private_service_connection.private_connection_resource_alias
    request_message                   = each.value.private_service_connection.request_message
  }

  tags = merge(var.default_tags, each.value.tags)

}
