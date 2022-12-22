
locals {
  all_pip_for_gateway = merge([
    for k_gw, v_gw in var.az_application_gateways : {
      for k_gw_ip, v_gw_ip in v_gw.frontend_ip_configuration :
      "${k_gw_ip}-${k_gw}" => {
        resource_group_name   = v_gw.resource_group_name
        location              = v_gw.location
        gw_name               = k_gw
        name                  = k_gw_ip
        auto_create_public_ip = v_gw_ip.auto_create_public_ip == null ? false : v_gw_ip.auto_create_public_ip
        public_ip_spec        = v_gw_ip.public_ip_spec
      }
    }
  ]...)

  all_agw_subnet = merge([
    for k_gw, v_gw in var.az_application_gateways : {
      for k_gw_ipc, v_gw_ipc in v_gw.gateway_ip_configuration :
      "${v_gw_ipc.subnet_name}-${k_gw_ipc}-${k_gw}" => {
        subnet_name = v_gw_ipc.subnet_name
        vnet_name   = v_gw_ipc.vnet_name
        vnet_resource_group_name = (v_gw_ipc.vnet_resource_group_name != null ? v_gw_ipc.vnet_resource_group_name :
        v_gw.resource_group_name)
      }
    }
  ]...)

}

data "azurerm_subnet" "subnet_gw_ip_conf" {
  for_each = local.all_agw_subnet

  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.vnet_resource_group_name
}

resource "azurerm_application_gateway" "app_gws" {
  for_each = var.az_application_gateways

  name                = each.key
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  tags                = merge(var.default_tags, each.value.tags)
  enable_http2        = each.value.enable_http2

  sku {
    name     = each.value.sku.name
    tier     = each.value.sku.tier
    capacity = each.value.sku.capacity
  }

  dynamic "identity" {
    for_each = each.value.identity == null ? [] : [each.value.identity]

    content {
      # Only possible value is UserAssigned
      type         = identity.value.type == null ? "UserAssigned" : identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "ssl_policy" {
    for_each = each.value.ssl_policy == null ? [] : [each.value.ssl_policy]

    content {
      policy_name          = ssl_policy.value.policy_name
      policy_type          = ssl_policy.value.policy_type
      disabled_protocols   = ssl_policy.value.disabled_protocols
      min_protocol_version = ssl_policy.value.min_protocol_version
      cipher_suites        = ssl_policy.value.cipher_suites
    }
  }

  dynamic "authentication_certificate" {
    for_each = each.value.authentication_certificates == null ? {} : each.value.authentication_certificates
    content {
      name = authentication_certificate.key
      data = authentication_certificate.value.data
    }
  }

  dynamic "trusted_client_certificate" {
    for_each = each.value.trusted_client_certificates == null ? {} : each.value.trusted_client_certificates

    content {
      name = trusted_client_certificate.key
      data = trusted_client_certificate.value.data
    }
  }

  dynamic "trusted_root_certificate" {
    for_each = each.value.trusted_root_certificates == null ? {} : each.value.trusted_root_certificates

    content {
      name                = trusted_root_certificate.key
      data                = trusted_root_certificate.value.data
      key_vault_secret_id = trusted_root_certificate.value.key_vault_secret_id
    }
  }

  dynamic "ssl_certificate" {
    for_each = each.value.ssl_certificates == null ? {} : each.value.ssl_certificates

    content {
      name                = ssl_certificate.key
      data                = ssl_certificate.value.data
      password            = ssl_certificate.value.password
      key_vault_secret_id = ssl_certificate.value.key_vault_secret_id
    }
  }

  dynamic "gateway_ip_configuration" {
    for_each = each.value.gateway_ip_configuration
    content {
      name = gateway_ip_configuration.key
      subnet_id = (gateway_ip_configuration.value.subnet_id != null ? gateway_ip_configuration.value.subnet_id :
      lookup(data.azurerm_subnet.subnet_gw_ip_conf, "${gateway_ip_configuration.value.subnet_name}-${gateway_ip_configuration.key}-${each.key}").id)
    }
  }

  dynamic "frontend_ip_configuration" {
    for_each = each.value.frontend_ip_configuration

    content {
      name = frontend_ip_configuration.key

      public_ip_address_id = (frontend_ip_configuration.value.public_ip_address_id != null ?
        frontend_ip_configuration.value.public_ip_address_id : try([for k, v in azurerm_public_ip.pip_agw :
      v.id if length(regexall(".*${frontend_ip_configuration.key}-${each.key}", v.name)) > 0][0], null))

      subnet_id                       = frontend_ip_configuration.value.subnet_id
      private_ip_address              = frontend_ip_configuration.value.private_ip_address
      private_ip_address_allocation   = frontend_ip_configuration.value.private_ip_address_allocation
      private_link_configuration_name = frontend_ip_configuration.value.private_link_configuration_name
    }
  }

  dynamic "frontend_port" {
    for_each = each.value.frontend_ports
    content {
      name = frontend_port.key
      port = frontend_port.value.port
    }
  }

  dynamic "request_routing_rule" {
    for_each = each.value.request_routing_rules
    content {
      name                        = request_routing_rule.key
      rule_type                   = request_routing_rule.value.rule_type
      http_listener_name          = request_routing_rule.value.http_listener_name
      backend_address_pool_name   = request_routing_rule.value.backend_address_pool_name
      backend_http_settings_name  = request_routing_rule.value.backend_http_settings_name
      redirect_configuration_name = request_routing_rule.value.redirect_configuration_name
      rewrite_rule_set_name       = request_routing_rule.value.rewrite_rule_set_name
      url_path_map_name           = request_routing_rule.value.url_path_map_name
      priority                    = request_routing_rule.value.priority
    }
  }
  dynamic "probe" {
    for_each = each.value.probes

    content {
      name                                      = probe.key
      host                                      = probe.value.host
      interval                                  = probe.value.interval
      protocol                                  = probe.value.protocol
      path                                      = probe.value.path
      unhealthy_threshold                       = probe.value.unhealthy_threshold
      port                                      = probe.value.port
      pick_host_name_from_backend_http_settings = probe.value.pick_host_name_from_backend_http_settings
      minimum_servers                           = probe.value.minimum_servers
      timeout                                   = probe.value.timeout

      dynamic "match" {
        for_each = probe.value.match == null ? [] : [probe.value.match]
        content {
          body        = match.value.body
          status_code = match.value.status_code
        }
      }
    }
  }

  dynamic "http_listener" {
    for_each = each.value.http_listeners
    content {
      name                           = http_listener.key
      frontend_ip_configuration_name = http_listener.value.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.frontend_port_name
      host_name                      = http_listener.value.host_name
      host_names                     = http_listener.value.host_names
      protocol                       = http_listener.value.protocol
      require_sni                    = http_listener.value.require_sni
      ssl_certificate_name           = http_listener.value.ssl_certificate_name

      firewall_policy_id = http_listener.value.firewall_policy_id
      ssl_profile_name   = http_listener.value.ssl_profile_name

      dynamic "custom_error_configuration" {
        for_each = http_listener.value.custom_error_configuration == null ? {} : http_listener.value.custom_error_configuration
        content {
          status_code           = custom_error_configuration.value.status_code
          custom_error_page_url = custom_error_configuration.value.custom_error_page_url
        }
      }
    }
  }

  dynamic "backend_http_settings" {
    for_each = each.value.backend_http_settings
    content {
      name                                = backend_http_settings.key
      cookie_based_affinity               = backend_http_settings.value.cookie_based_affinity
      affinity_cookie_name                = backend_http_settings.value.affinity_cookie_name
      path                                = backend_http_settings.value.path
      port                                = backend_http_settings.value.port
      probe_name                          = backend_http_settings.value.probe_name
      protocol                            = backend_http_settings.value.protocol
      request_timeout                     = backend_http_settings.value.request_timeout
      host_name                           = backend_http_settings.value.host_name
      pick_host_name_from_backend_address = backend_http_settings.value.pick_host_name_from_backend_address
      trusted_root_certificate_names      = backend_http_settings.value.trusted_root_certificate_names
      dynamic "authentication_certificate" {
        for_each = backend_http_settings.value.authentication_certificate == null ? {} : backend_http_settings.value.authentication_certificate
        content {
          name = authentication_certificate.key
        }
      }

      dynamic "connection_draining" {
        for_each = backend_http_settings.value.connection_draining == null ? [] : [backend_http_settings.value.connection_draining]
        content {
          enabled           = connection_draining.value.enabled
          drain_timeout_sec = connection_draining.value.drain_timeout_sec
        }
      }
    }
  }
  dynamic "backend_address_pool" {
    for_each = each.value.backend_address_pools
    content {
      name         = backend_address_pool.key
      fqdns        = backend_address_pool.value.fqdns
      ip_addresses = backend_address_pool.value.ip_addresses
    }
  }

  dynamic "waf_configuration" {
    for_each = each.value.waf_configuration == null ? [] : [each.value.waf_configuration]

    content {
      enabled                  = waf_configuration.value.enabled
      firewall_mode            = waf_configuration.value.firewall_mode
      rule_set_type            = waf_configuration.value.rule_set_type
      rule_set_version         = waf_configuration.value.rule_set_version
      file_upload_limit_mb     = waf_configuration.value.file_upload_limit_mb
      request_body_check       = waf_configuration.value.request_body_check
      max_request_body_size_kb = waf_configuration.value.max_request_body_size_kb

      dynamic "disabled_rule_group" {
        for_each = waf_configuration.value.disabled_rule_group == null ? [] : [waf_configuration.value.disabled_rule_group]
        content {
          rule_group_name = disabled_rule_group.key
          rules           = disabled_rule_group.value.rules
        }
      }

      dynamic "exclusion" {
        for_each = waf_configuration.value.exclusion == null ? [] : [waf_configuration.value.exclusion]
        iterator = waf_conf_exclusion
        content {
          match_variable          = waf_conf_exclusion.key
          selector_match_operator = waf_conf_exclusion.value.selector_match_operator
          selector                = waf_conf_exclusion.value.selector
        }
      }
    }
  }

  dynamic "rewrite_rule_set" {
    for_each = each.value.rewrite_rule_set == null ? {} : each.value.rewrite_rule_set

    content {
      name = rewrite_rule_set.key

      dynamic "rewrite_rule" {
        for_each = rewrite_rule_set.value.rewrite_rule
        content {
          name          = rewrite_rule.key
          rule_sequence = rewrite_rule.value.rule_sequence

          dynamic "condition" {
            for_each = rewrite_rule.value.condition == null ? [] : rewrite_rule.value.condition

            content {
              variable    = condition.value.variable
              pattern     = condition.value.pattern
              ignore_case = condition.value.ignore_case
              negate      = condition.value.negate
            }
          }

          dynamic "request_header_configuration" {
            for_each = rewrite_rule.value.request_header_configuration == null ? [] : rewrite_rule.value.request_header_configuration
            content {
              header_name  = request_header_configuration.value.header_name
              header_value = request_header_configuration.value.header_value
            }
          }

          dynamic "response_header_configuration" {
            for_each = rewrite_rule.value.response_header_configuration == null ? [] : rewrite_rule.value.response_header_configuration
            content {
              header_name  = response_header_configuration.value.header_name
              header_value = response_header_configuration.value.header_value
            }
          }

          dynamic "url" {
            for_each = rewrite_rule.value.url == null ? [] : [rewrite_rule.value.url]
            iterator = rewrite_rule_url
            content {
              path         = rewrite_rule_url.value.path
              query_string = rewrite_rule_url.value.query_string
              reroute      = rewrite_rule_url.value.reroute
            }
          }
        }
      }
    }
  }
  dynamic "autoscale_configuration" {
    for_each = each.value.autoscale_configuration == null ? [] : [each.value.autoscale_configuration]
    content {
      min_capacity = autoscale_configuration.value.min_capacity
      max_capacity = autoscale_configuration.value.max_capacity
    }
  }

  dynamic "url_path_map" {
    for_each = each.value.url_path_maps == null ? {} : each.value.url_path_maps

    content {
      name                                = url_path_map.key
      default_backend_address_pool_name   = url_path_map.value.default_backend_address_pool_name
      default_backend_http_settings_name  = url_path_map.value.default_backend_http_settings_name
      default_redirect_configuration_name = url_path_map.value.default_redirect_configuration_name
      default_rewrite_rule_set_name       = url_path_map.value.default_rewrite_rule_set_name
      dynamic "path_rule" {
        for_each = url_path_map.value.path_rule

        content {
          name                        = path_rule.key
          paths                       = path_rule.value.paths
          backend_address_pool_name   = path_rule.value.backend_address_pool_name
          backend_http_settings_name  = path_rule.value.backend_http_settings_name
          rewrite_rule_set_name       = path_rule.value.rewrite_rule_set_name
          redirect_configuration_name = path_rule.value.redirect_configuration_name
        }
      }
    }
  }

  dynamic "redirect_configuration" {
    for_each = each.value.redirect_configurations == null ? {} : each.value.redirect_configurations

    content {
      name                 = redirect_configuration.key
      redirect_type        = redirect_configuration.value.redirect_type
      target_listener_name = redirect_configuration.value.target_listener_name
      target_url           = redirect_configuration.value.target_url
      include_path         = redirect_configuration.value.include_path
      include_query_string = redirect_configuration.value.include_query_string
    }
  }
}

resource "azurerm_public_ip" "pip_agw" {
  for_each = { for k, v in local.all_pip_for_gateway : k => v if v.auto_create_public_ip }

  name                    = "pip-${each.value.name}-${each.value.gw_name}"
  resource_group_name     = each.value.resource_group_name
  location                = each.value.location
  sku                     = each.value.public_ip_spec.sku
  sku_tier                = each.value.public_ip_spec.sku_tier
  allocation_method       = each.value.public_ip_spec.allocation_method
  edge_zone               = each.value.public_ip_spec.edge_zone
  domain_name_label       = each.value.public_ip_spec.domain_name_label
  idle_timeout_in_minutes = each.value.public_ip_spec.idle_timeout_in_minutes
  ip_version              = each.value.public_ip_spec.ip_version
  ip_tags                 = each.value.public_ip_spec.ip_tags

  tags = var.default_tags
}
