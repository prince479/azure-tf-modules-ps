
locals {
  all_route_map = try(merge(flatten([
    for k_rt, v_rt in var.route_tables : {
      for k_r, v_r in v_rt.routes : "${k_r}-${k_rt}" =>
      {
        rt_name                = k_rt
        route_name             = k_r
        address_prefix         = v_r.address_prefix
        next_hop_type          = v_r.next_hop_type
        next_hop_in_ip_address = v_r.next_hop_in_ip_address
      }
    } if v_rt.routes != null
  ])...), {})

  all_subnet_map = try(merge(flatten([
    for k_rt, v_rt in var.route_tables : {
      for k_snet, v_snet in v_rt.subnet_names_association : "${k_snet}-${k_rt}" =>
      {
        rt_name             = k_rt
        subnet_name         = k_snet
        vnet_name           = v_snet.vnet_name
        resource_group_name = v_snet.resource_group_name
      }
    } if v_rt.subnet_names_association != null
  ])...), {})

}

data "azurerm_subnet" "rt_assoc_subnet" {
  for_each = local.all_subnet_map

  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.vnet_name
  name                 = each.value.subnet_name

}

resource "azurerm_route_table" "route_table_001" {
  for_each = var.route_tables

  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  name                = each.key

  tags = merge(var.default_tags, each.value.tags)

  dynamic "route" {
    for_each = { for k, v in local.all_route_map : k => v if length(regexall("${v.rt_name}", each.key)) > 0 }

    content {
      name                   = "r_${route.value.route_name}-${each.key}"
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_in_ip_address
    }
  }
}

resource "azurerm_subnet_route_table_association" "rt_assoc_001" {
  for_each = local.all_subnet_map

  subnet_id = [for k, v in data.azurerm_subnet.rt_assoc_subnet : v.id
  if each.value.subnet_name == v.name && each.value.resource_group_name == v.resource_group_name][0]

  route_table_id = [for k, v in azurerm_route_table.route_table_001 : v.id if each.value.rt_name == v.name][0]
}
