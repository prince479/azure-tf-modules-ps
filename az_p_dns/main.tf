locals {
  all_dns_a_record_map = try(merge(flatten([
    for k_dns_z, v_dns_z in var.private_dns_zones : {
      for k_record, v_record in v_dns_z.a_records : "${k_record}-${k_dns_z}" =>
      {
        resource_group_name = v_dns_z.resource_group_name
        name                = k_record
        zone_name           = k_dns_z
        ttl                 = v_record.ttl
        records             = v_record.records
        tags                = v_dns_z.tags
      }
    } if v_dns_z.a_records != null
  ])...), {})

  all_dns_cname_record_map = try(merge(flatten([
    for k_dns_z, v_dns_z in var.private_dns_zones : {
      for k_record, v_record in v_dns_z.cname_records : "${k_record}-${k_dns_z}" =>
      {
        resource_group_name = v_dns_z.resource_group_name
        name                = k_record
        zone_name           = k_dns_z
        ttl                 = v_record.ttl
        record              = v_record.record
        tags                = v_dns_z.tags
      }
    } if v_dns_z.cname_records != null
  ])...), {})

  all_soa_record_map = try(merge({
    for k_dns_z, v_dns_z in var.private_dns_zones : k_dns_z =>
    {
      p_dns_name   = k_dns_z
      email        = v_dns_z.soa_record.email
      expire_time  = v_dns_z.soa_record.expire_time
      minimum_ttl  = v_dns_z.soa_record.minimum_ttl
      refresh_time = v_dns_z.soa_record.refresh_time
      retry_time   = v_dns_z.soa_record.retry_time
      ttl          = v_dns_z.soa_record.ttl
      tags         = v_dns_z.tags
    } if v_dns_z.soa_record != null
  }...), {})

  all_vnet_link_map = try(merge(flatten([
    for k_dns_z, v_dns_z in var.private_dns_zones : {
      for k_vnet, v_vnet in v_dns_z.vnet_link_names : "${k_vnet}-${k_dns_z}" =>
      {
        resource_group_name   = v_dns_z.resource_group_name
        vnet_name             = k_vnet
        private_dns_zone_name = k_dns_z
        virtual_network_id    = v_vnet.virtual_network_id
        registration_enabled  = v_vnet.registration_enabled
        tags                  = v_vnet.tags
        inherit_tags          = v_vnet.inherit_tags == null ? true : v_vnet.inherit_tags
      }
    }
  ])...), {})

  all_vnet_name_map = try(merge(flatten([
    for k_dns_z, v_dns_z in var.private_dns_zones : {
      for k_vnet, v_vnet in v_dns_z.vnet_link_names : "${k_vnet}-${k_dns_z}" =>
      {
        vnet_name           = k_vnet
        resource_group_name = v_vnet.resource_group_name
      }
    }
  ])...), {})

}

resource "azurerm_private_dns_zone" "main" {
  for_each = var.private_dns_zones

  resource_group_name = each.value.resource_group_name
  name                = each.key

  dynamic "soa_record" {
    for_each = { for k, v in local.all_soa_record_map : k => v if v.p_dns_name == each.key }

    content {
      email        = soa_record.value.email
      expire_time  = soa_record.value.expire_time
      minimum_ttl  = soa_record.value.minimum_ttl
      refresh_time = soa_record.value.refresh_time
      retry_time   = soa_record.value.retry_time
      ttl          = soa_record.value.ttl
      tags         = soa_record.value.tags
    }
  }

  tags = merge(var.default_tags, each.value.tags)
}

resource "azurerm_private_dns_a_record" "a_records_main" {
  for_each = local.all_dns_a_record_map

  resource_group_name = each.value.resource_group_name
  name                = each.value.name
  zone_name           = each.value.zone_name

  ttl     = each.value.ttl
  records = each.value.records
  tags    = merge(var.default_tags, each.value.tags)

  depends_on = [
    azurerm_private_dns_zone.main
  ]
}

resource "azurerm_private_dns_cname_record" "cname_records_main" {
  for_each = local.all_dns_cname_record_map

  resource_group_name = each.value.resource_group_name
  name                = each.value.name
  zone_name           = each.value.zone_name

  ttl    = each.value.ttl
  record = each.value.record
  tags   = merge(var.default_tags, each.value.tags)

  depends_on = [
    azurerm_private_dns_zone.main
  ]
}

data "azurerm_virtual_network" "vnet_data" {
  for_each = { for k, v in local.all_vnet_name_map : k => v if v.resource_group_name != null }

  name                = each.value.vnet_name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_network_links" {
  for_each = { for k, v in local.all_vnet_link_map : "${v.private_dns_zone_name}_${v.vnet_name}" => v }

  name                  = each.value.vnet_name
  resource_group_name   = each.value.resource_group_name
  private_dns_zone_name = each.value.private_dns_zone_name
  registration_enabled  = each.value.registration_enabled
  virtual_network_id = (each.value.virtual_network_id != null ? each.value.virtual_network_id :
  [for k, v in data.azurerm_virtual_network.vnet_data : v.id if v.name == each.value.vnet_name][0])

  tags = each.value.inherit_tags ? merge(var.default_tags, each.value.tags) : each.value.tags

  depends_on = [
    azurerm_private_dns_zone.main
  ]
}
