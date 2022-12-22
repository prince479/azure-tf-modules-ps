

locals {
  all_pip_map = {
    for k_ngw, v_ngw in var.nat_gateways : k_ngw =>
    {
      nat_gateway_name = k_ngw
      zones            = v_ngw.zones
      location         = v_ngw.location

      resource_group_name = try(v_ngw.public_ip_spec.resource_group_name != null ?
        v_ngw.public_ip_spec.resource_group_name : v_ngw.resource_group_name,
      v_ngw.resource_group_name)

      allocation_method = try(v_ngw.public_ip_spec.allocation_method != null ? v_ngw.public_ip_spec.allocation_method : "Static", "Static")
      sku               = try(v_ngw.public_ip_spec.sku != null ? v_ngw.public_ip_spec.sku : "Standard", "Standard")

      ip_prefix_length = v_ngw.ip_prefix_length

      tags = try(v_ngw.public_ip_spec.tags != null ?
      v_ngw.public_ip_spec.tags : v_ngw.tags, v_ngw.tags)
    }
  }

  all_subnet_map = try(merge(flatten([
    for k_ngw, v_ngw in var.nat_gateways : {
      for v_snet in v_ngw.associated_subnets : "${v_snet}-${k_ngw}" =>
      {
        nat_gateway_name = k_ngw
        subnet_id        = v_snet
      }
    }
  ])...), {})
}

resource "azurerm_public_ip" "pip" {
  for_each = local.all_pip_map

  name                = "pip-${each.value.nat_gateway_name}"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku
  zones               = each.value.zones

  tags = merge(var.default_tags, each.value.tags)
}

resource "azurerm_nat_gateway_public_ip_association" "ngw_pip_assoc" {
  for_each = azurerm_nat_gateway.main

  nat_gateway_id       = each.value.id
  public_ip_address_id = [for k, v in azurerm_public_ip.pip : v.id if length(regexall("pip-${each.value.name}", v.name)) > 0][0]
}

resource "azurerm_public_ip_prefix" "ippre" {
  for_each = local.all_pip_map

  name                = "ippre-${each.value.nat_gateway_name}"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  prefix_length       = each.value.ip_prefix_length
  zones               = each.value.zones

  tags = merge(var.default_tags, each.value.tags)
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "ngw_ippre_assoc" {
  for_each = azurerm_nat_gateway.main

  nat_gateway_id      = each.value.id
  public_ip_prefix_id = [for k, v in azurerm_public_ip_prefix.ippre : v.id if length(regexall("ippre-${each.value.name}", v.name)) > 0][0]
}

resource "azurerm_nat_gateway" "main" {
  for_each = var.nat_gateways

  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  name                = each.key

  sku_name = each.value.sku_name
  zones    = each.value.zones

  tags = merge(var.default_tags, each.value.tags)
}

# data "azurerm_subnet" "subnet_data" {
#   for_each = local.all_subnet_map

#   name                 = each.value.subnet_name
#   virtual_network_name = each.value.vnet_name
#   resource_group_name  = each.value.resource_group_name
# }
resource "azurerm_subnet_nat_gateway_association" "ngw_assoc" {
  for_each = local.all_subnet_map

  subnet_id      = each.value.subnet_id
  nat_gateway_id = [for k, v in azurerm_nat_gateway.main : v.id if each.value.nat_gateway_name == v.name][0]
}
