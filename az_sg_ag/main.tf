
locals {
  all_security_rule_map = try(merge(flatten([
    for k_nsg, v_nsg in var.network_security_groups : {
      for k_rule, v_rule in v_nsg.security_rules : "${k_rule}-${k_nsg}" =>
      merge(v_rule, {
        nsg_name  = k_nsg
        rule_name = k_rule
      })
    } if v_nsg.security_rules != null
  ])...), {})

  all_subnet_assoc_map = try(merge(flatten([
    for k_nsg, v_nsg in var.network_security_groups : {
      for v_snet in v_nsg.subnet_association_ids : "${v_snet}-${k_nsg}" =>
      {
        nsg_name  = k_nsg
        subnet_id = v_snet
      }

    } if v_nsg.subnet_association_ids != null
  ])...), {})
}

resource "azurerm_application_security_group" "az_asg_resources" {
  for_each = var.application_security_groups

  name                = each.key
  location            = each.value.location == null ? var.default_location : each.value.location
  resource_group_name = each.value.resource_group_name == null ? var.default_resource_group_name : each.value.resource_group_name

  tags = merge(var.default_tags, each.value.tags)
}

resource "azurerm_network_security_group" "az_nsg_resources" {
  for_each            = var.network_security_groups
  name                = each.key
  location            = each.value.location == null ? var.default_location : each.value.location
  resource_group_name = each.value.resource_group_name == null ? var.default_resource_group_name : each.value.resource_group_name

  dynamic "security_rule" {
    for_each = local.all_security_rule_map

    content {
      name                       = security_rule.value.rule_name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }

  tags = merge(var.default_tags, each.value.tags)
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  for_each                  = local.all_subnet_assoc_map
  subnet_id                 = each.value.subnet_id
  network_security_group_id = [for k, v in azurerm_network_security_group.az_nsg_resources : v.id if each.value.nsg_name == v.name][0]
}
