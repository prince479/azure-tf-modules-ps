
locals {
  all_pip_afw_map = merge(flatten([
    for k_afw, v_afw in var.azure_firewalls : {
      for k_ipconf, v_ipconf in v_afw.ip_configuration :
      "${k_ipconf}-${k_afw}" => merge(v_ipconf, {
        afw_name            = k_afw
        resource_group_name = v_afw.resource_group_name
        location            = v_afw.location
      })
    } if v_afw.ip_configuration != null
  ])...)

  all_fw_policy_match_map = {
    for k_afp, v_afp in var.azure_firewall_policies : k_afp => {

      firewall_policy_name = k_afp
      firewall_assoc_name  = v_afp.associated_to_afw_name
    } if v_afp.associated_to_afw_name != null
  }

  all_firewall_policy_rule_collection_group_map = {
    for k_afprc, v_afprc in var.azurerm_firewall_policy_rule_collection_group : k_afprc =>
    {
      firewall_policy_rule_collection_group_name = k_afprc
      firewall_policy_name                       = v_afprc.associated_to_afw_policy_name
    }
    if v_afprc.associated_to_afw_policy_name != null
  }
}

data "azurerm_subnet" "snet_for_ipconf" {
  for_each = { for k, v in local.all_pip_afw_map : k => v if v.subnet_name != null }

  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.vnet_resource_group_name == null ? each.value.resource_group_name : each.value.vnet_resource_group_name
}

resource "azurerm_public_ip" "main" {
  for_each = local.all_pip_afw_map

  name                = each.value.public_name == null ? "pip-${each.value.afw_name}" : each.value.public_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "main" {
  for_each = var.azure_firewalls

  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  name                = each.key

  sku_name = each.value.sku_name
  sku_tier = each.value.sku_tier
  firewall_policy_id = (each.value.firewall_policy_id != null ? each.value.firewall_policy_id : local.all_fw_policy_match_map == {} ? null :
    [for k, v in local.all_fw_policy_match_map :
    azurerm_firewall_policy.main[v.firewall_policy_name].id if azurerm_firewall_policy.main[v.firewall_policy_name] != null && each.key == v.firewall_assoc_name][0] == [] ? null :
    [for k, v in local.all_fw_policy_match_map :
  azurerm_firewall_policy.main[v.firewall_policy_name].id if azurerm_firewall_policy.main[v.firewall_policy_name] != null && each.key == v.firewall_assoc_name][0])

  threat_intel_mode = each.value.threat_intel_mode

  dynamic "ip_configuration" {
    for_each = each.value.ip_configuration != null ? each.value.ip_configuration : {}

    content {
      name      = ip_configuration.key
      subnet_id = ip_configuration.value.subnet_id != null ? ip_configuration.value.subnet_id : [for k, v in data.azurerm_subnet.snet_for_ipconf : v.id if k == "${ip_configuration.key}-${each.key}"][0]
      public_ip_address_id = (ip_configuration.value.public_ip_address_id == null ?
        [for k, v in azurerm_public_ip.main : v.id if k == "${ip_configuration.key}-${each.key}"][0] :
      ip_configuration.value.public_ip_address_id)
    }
  }

  tags = merge(var.default_tags, each.value.tags)

  depends_on = [
    azurerm_firewall_policy.main
  ]
}

resource "azurerm_firewall_policy" "main" {
  for_each = var.azure_firewall_policies

  name                     = each.key
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  threat_intelligence_mode = each.value.threat_intelligence_mode
  tags                     = merge(var.default_tags, each.value.tags)
  dynamic "identity" {
    for_each = each.value.identity == null ? [] : [each.value.identity]
    iterator = iden
    content {
      type         = lookup(iden.value, "type")
      identity_ids = lookup(iden.value, "identity_ids")
    }
  }

  dynamic "insights" {
    for_each = each.value.insights == null ? [] : [each.value.insights]

    content {
      enabled                            = lookup(insights.value, "enabled")
      default_log_analytics_workspace_id = lookup(insights.value, "default_log_analytics_workspace_id")
      retention_in_days                  = lookup(insights.value, "retention_in_days")
      dynamic "log_analytics_workspace" {
        for_each = insights.value.log_analytics_workspace

        content {
          id                = log_analytics_workspace.value.id
          firewall_location = log_analytics_workspace.value.firewall_location
        }
      }
    }
  }

  dynamic "intrusion_detection" {
    for_each = each.value.intrusion_detection == null ? [] : [each.value.intrusion_detection]
    iterator = in_de
    content {
      mode = lookup(in_de.value, "mode")
      dynamic "signature_overrides" {
        for_each = in_de.value.signature_overrides == null ? {} : in_de.value.signature_overrides
        content {
          id    = signature_overrides.value.id
          state = signature_overrides.value.state
        }
      }
      dynamic "traffic_bypass" {
        for_each = in_de.value.traffic_bypass == null ? {} : in_de.value.traffic_bypass
        content {
          name                  = traffic_bypass.key
          protocol              = traffic_bypass.value.protocol
          description           = traffic_bypass.value.description
          destination_addresses = traffic_bypass.value.destination_addresses
          destination_ip_groups = traffic_bypass.value.destination_ip_groups
          destination_ports     = traffic_bypass.value.destination_ports
          source_addresses      = traffic_bypass.value.source_addresses
          source_ip_groups      = traffic_bypass.value.source_ip_groups
        }
      }
    }
  }

  dynamic "threat_intelligence_allowlist" {
    for_each = each.value.threat_intelligence_allowlist == null ? [] : [each.value.threat_intelligence_allowlist]
    iterator = tia
    content {
      fqdns        = lookup(tia.value, "fqdns", null)
      ip_addresses = lookup(tia.value, "ip_addresses", null)
    }
  }

  dynamic "tls_certificate" {
    for_each = each.value.tls_certificate == null ? [] : [each.value.tls_certificate]
    iterator = tls_cert
    content {
      name                = lookup(tls_cert.value, "name", null)
      key_vault_secret_id = lookup(tls_cert.value, "key_vault_secret_id", null)
    }
  }
}


resource "azurerm_firewall_policy_rule_collection_group" "main" {
  for_each = var.azurerm_firewall_policy_rule_collection_group

  name     = each.key
  priority = each.value.priority
  firewall_policy_id = (each.value.firewall_policy_id != null ? each.value.firewall_policy_id : local.all_firewall_policy_rule_collection_group_map == {} ? null :
    [for k, v in local.all_firewall_policy_rule_collection_group_map :
    azurerm_firewall_policy.main[v.firewall_policy_name].id if azurerm_firewall_policy.main[v.firewall_policy_name] != null && each.key == v.firewall_policy_rule_collection_group_name][0] == [] ? null :
    [for k, v in local.all_firewall_policy_rule_collection_group_map :
  azurerm_firewall_policy.main[v.firewall_policy_name].id if azurerm_firewall_policy.main[v.firewall_policy_name] != null && each.key == v.firewall_policy_rule_collection_group_name][0])

  dynamic "application_rule_collection" {
    for_each = each.value.application_rule_collection
    iterator = arc
    content {
      name     = arc.key
      priority = lookup(arc.value, "priority", null)
      action   = lookup(arc.value, "action", null)
      dynamic "rule" {
        for_each = lookup(arc.value, "rule", {})
        content {
          name              = rule.key
          source_addresses  = lookup(rule.value, "source_addresses", null)
          destination_fqdns = lookup(rule.value, "destination_fqdns", null)
          dynamic "protocols" {
            for_each = lookup(rule.value, "protocols", {})
            content {
              type = protocols.key
              port = protocols.value.port
            }
          }
        }
      }
    }
  }
}
