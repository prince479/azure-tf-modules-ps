terraform {
  
}

locals {
  all_subnet = flatten([
    for k_bast, v_bast in var.bastion_hosts : v_bast.ip_configuration == null ? [] : [
      {
        vnet_name           = v_bast.ip_configuration.vnet_name
        resource_group_name = v_bast.resource_group_name
      }
    ]
  ])
  all_subnet_map = { for k, v in local.all_subnet : k => v }
}

data "azurerm_subnet" "bas_target_subnet_data" {
  for_each = local.all_subnet_map
  # This is mandatory subnet name.
  name = "AzureBastionSubnet"

  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.resource_group_name
}

resource "azurerm_public_ip" "pip_prep" {
  for_each = var.bastion_hosts

  name                = "pip-${each.key}"
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  # These are mandatory spec.
  allocation_method = "Static"
  sku               = "Standard"

  tags = each.value.tags
}

resource "azurerm_bastion_host" "main" {
  for_each = var.bastion_hosts

  name                = each.key
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = each.value.sku
  tunneling_enabled   = each.value.tunneling_enabled

  copy_paste_enabled     = each.value.copy_paste_enabled
  file_copy_enabled      = each.value.file_copy_enabled
  ip_connect_enabled     = each.value.ip_connect_enabled
  scale_units            = each.value.scale_units
  shareable_link_enabled = each.value.shareable_link_enabled

  dynamic "ip_configuration" {
    for_each = each.value.ip_configuration == null ? [] : [each.value.ip_configuration]
    content {
      name                 = "ipconf-${each.key}"
      subnet_id            = [for k, v in data.azurerm_subnet.bas_target_subnet_data : v.id if each.value.resource_group_name == v.resource_group_name && ip_configuration.value.vnet_name == v.virtual_network_name][0]
      public_ip_address_id = [for k, v in azurerm_public_ip.pip_prep : v.id if "pip-${each.key}" == v.name][0]
    }
  }
  tags = each.value.tags

  depends_on = [
    azurerm_public_ip.pip_prep
  ]
}
