locals {
  all_subnet_for_integration_map = merge({
    for k_int, v_int in var.app_service_vnet_integretion :
    "${v_int.subnet_name}-${k_int}" => {
      subnet_name           = v_int.subnet_name
      subnet_resource_group = v_int.subnet_resource_group
      vnet_name             = v_int.vnet_name
    } if v_int.subnet_name != null && v_int.subnet_resource_group != null && v_int.vnet_name != null
    },
    {
      for k_int, v_int in var.app_service_slot_vnet_integretion :
      "${v_int.subnet_name}-${k_int}" => {
        subnet_name           = v_int.subnet_name
        subnet_resource_group = v_int.subnet_resource_group
        vnet_name             = v_int.vnet_name
      } if v_int.subnet_name != null && v_int.subnet_resource_group != null && v_int.vnet_name != null
    }
  )
}

data "azurerm_subnet" "for_integration_subnet_data" {
  for_each = local.all_subnet_for_integration_map

  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.subnet_resource_group
}
/*
data "azurerm_storage_account" "storage" {
  name                = var.logs_storage_account_name
  resource_group_name = var.logs_storage_resource_group_name 
}

data "azurerm_storage_container" "container" {
  name                 = var.logs_container_name
  storage_account_name = var.logs_storage_account_name
}

data "azurerm_storage_account_blob_container_sas" "sas_url" {
  connection_string = data.azurerm_storage_account.storage.primary_connection_string
  container_name    = data.azurerm_storage_container.container.name
  https_only        = true

  start  = "2022-09-23"
  expiry = "2023-09-22"

  permissions {
    read   = true
    add    = true
    create = false
    write  = false
    delete = true
    list   = true
  }

  cache_control       = "max-age=5"
  content_disposition = "inline"
  content_encoding    = "deflate"
  content_language    = "en-US"
  content_type        = "application/json"
}
*/



# data "azurerm_subnet" "ase_target_subnet_data" {
#   for_each = var.app_services_environment_v3

#   name                 = each.value.subnet_name
#   virtual_network_name = each.value.vnet_name
#   resource_group_name  = each.value.vnet_resource_group
# }

# resource "azurerm_app_service_environment_v3" "ase_v3_main" {
#   for_each = var.app_services_environment_v3

#   resource_group_name                    = each.value.resource_group_name
#   name                                   = each.key
#   subnet_id                              = [for k, v in data.azurerm_subnet.ase_target_subnet_data : v.id if v.name == each.value.subnet_name][0]
#   internal_load_balancing_mode           = each.value.internal_load_balancing_mode
#   allow_new_private_endpoint_connections = each.value.allow_new_private_endpoint_connections
#   zone_redundant                         = each.value.zone_redundant

#   dynamic "cluster_setting" {
#     for_each = each.value.cluster_setting

#     content {
#       name  = cluster_setting.key
#       value = cluster_setting.value
#     }
#   }

#   tags = merge(var.default_tags, each.value.tags)
# }

resource "azurerm_service_plan" "app_plans_main" {
  for_each = var.app_services_plan

  resource_group_name        = var.app_service_resource_group_name
  location                   = var.app_service_location
  name                       = each.key
  app_service_environment_id = each.value.app_service_env_v3_name #each.value.app_service_env_v3_name == null ? null : [for k, v in azurerm_app_service_environment_v3.ase_v3_main : v.id if k == each.value.app_service_env_v3_name][0]

  sku_name                 = each.value.sku_name
  os_type                  = each.value.os_type
  worker_count             = each.value.worker_count
  per_site_scaling_enabled = each.value.per_site_scaling_enabled

  tags = merge(var.default_tags, each.value.tags)

  # depends_on = [
  #   azurerm_app_service_environment_v3.ase_v3_main
  # ]
}

/*
resource "azurerm_monitor_metric_alert" "metric" {
  for_each = var.alerts_dev
  name                = each.value.name
  resource_group_name = each.value.resource_group_name != null ? each.value.resource_group_name : var.app_service_resource_group_name
  scopes              = [each.value.scopes]
  description         = each.value.description
  frequency           = each.value.frequency
  window_size         = each.value.window_size
  severity            = each.value.severity

dynamic "criteria" {
    for_each = each.value.criteria == null ? [] : [each.value.criteria]
    content {
      metric_namespace = lookup(criteria.value, "metric_namespace", null)
      metric_name      = lookup(criteria.value, "metric_name", null)
      aggregation      = lookup(criteria.value, "aggregation", null)
      operator         = lookup(criteria.value, "operator", null)
      threshold        = lookup(criteria.value, "threshold", null)
    }
  }
  action {
    action_group_id = var.action_group_id
  }
}

resource "azurerm_monitor_activity_log_alert" "main" {
  for_each = var.activitylog_alerts_dev
  name                = each.value.name
  resource_group_name = each.value.resource_group_name != null ? each.value.resource_group_name : var.app_service_resource_group_name
  scopes              = [each.value.scopes]
  description         = each.value.description

dynamic "criteria" {
  for_each = each.value.criteria == null ? [] : [each.value.criteria]
  content {
    resource_id    = lookup(criteria.value, "resource_id", null)
    operation_name = lookup(criteria.value, "operation_name", null)
    category       = lookup(criteria.value, "category", null)
  }
}

  action {
    action_group_id = var.action_group_id
  }
}*/

resource "azurerm_windows_web_app" "app_windows_main" {
  for_each = var.app_windows_services
  resource_group_name     = each.value.resource_group_name != null ? each.value.resource_group_name : var.app_service_resource_group_name
  location                = var.app_service_location
  name                    = each.key
  service_plan_id         = [for k, v in azurerm_service_plan.app_plans_main : v.id if k == each.value.app_service_plan_name][0]
  client_affinity_enabled = each.value.client_affinity_enabled
  https_only              = true

  tags = merge(var.default_tags, each.value.tags)

  app_settings = each.value.app_settings
  dynamic "auth_settings" {
    for_each = each.value.auth_settings == null ? [] : [each.value.auth_settings]
    content {
      enabled = true
      #active_directory {}
      additional_login_parameters    = lookup(auth_settings.value, "additional_login_params", null)
      allowed_external_redirect_urls = lookup(auth_settings.value, "allowed_external_redirect_urls", null)
      default_provider               = lookup(auth_settings.value, "default_provider", null)
      issuer                         = lookup(auth_settings.value, "issuer", null)
      #microsoft {}
      runtime_version               = lookup(auth_settings.value, "runtime_version", null)
      token_refresh_extension_hours = lookup(auth_settings.value, "token_refresh_extension_hours", null)
      token_store_enabled           = lookup(auth_settings.value, "token_store_enabled", null)
      unauthenticated_client_action = lookup(auth_settings.value, "unauthenticated_client_action", null)
    }
  }
  
  client_certificate_enabled = true


  dynamic "sticky_settings" {
    for_each = each.value.sticky_settings == null ? [] : [each.value.sticky_settings]

    content {
      app_setting_names       = sticky_settings.value.app_setting_names
      connection_string_names = sticky_settings.value.connection_string_names
    }
  }

 
  dynamic "connection_string" {
    for_each = each.value.connection_string == null ? [] : [each.value.connection_string]
    content {
      name       = lookup(connection_string.value, "name", null)
      type       = lookup(connection_string.value, "type", null)
      value      = lookup(connection_string.value, "value", null)
    }
  }

  dynamic "site_config" { 
    for_each = each.value.site_config == null ? [] : [each.value.site_config]
    content {
      http2_enabled          = lookup(site_config.value, "http2_enabled", null)
      vnet_route_all_enabled = lookup(site_config.value, "vnet_route_all_enabled", null)
      always_on              = lookup(site_config.value, "always_on", null)
      app_command_line       = lookup(site_config.value, "app_command_line", null)
      health_check_path      = lookup(site_config.value, "health_check_path", null)
      ftps_state             = "FtpsOnly"
      

      default_documents                 = lookup(site_config.value, "default_documents", null)
      health_check_eviction_time_in_min = lookup(site_config.value, "health_check_eviction_time_in_min", null)
      load_balancing_mode               = lookup(site_config.value, "load_balancing_mode", null)
      local_mysql_enabled               = lookup(site_config.value, "local_mysql_enabled", null)
      managed_pipeline_mode             = lookup(site_config.value, "managed_pipeline_mode", null)
      minimum_tls_version               = "1.2"
      remote_debugging_enabled          = lookup(site_config.value, "remote_debugging_enabled", null)
      remote_debugging_version          = lookup(site_config.value, "remote_debugging_version", null)
      scm_minimum_tls_version           = "1.2"
      scm_use_main_ip_restriction       = lookup(site_config.value, "scm_use_main_ip_restriction", null)
      use_32_bit_worker                 = lookup(site_config.value, "use_32_bit_worker", null)
      websockets_enabled                = lookup(site_config.value, "websockets_enabled", null)
      worker_count                      = lookup(site_config.value, "worker_count", null)

      dynamic "ip_restriction" {
        for_each = site_config.value.ip_restriction == null ? {} : site_config.value.ip_restriction
        content {
          name                      = ip_restriction.key
          action                    = lookup(ip_restriction.value, "action", null)
          ip_address                = lookup(ip_restriction.value, "ip_address", null)
          priority                  = lookup(ip_restriction.value, "priority", null)
          service_tag               = lookup(ip_restriction.value, "service_tag", null)
          virtual_network_subnet_id = lookup(ip_restriction.value, "virtual_network_subnet_id", null)
          dynamic "headers" {
            for_each = ip_restriction.value.headers == null ? [] : [ip_restriction.value.headers]
            content {
              x_azure_fdid      = lookup(headers.value, "x_azure_fdid", null)
              x_fd_health_probe = lookup(headers.value, "x_fd_health_probe", null)
              x_forwarded_for   = lookup(headers.value, "x_forwarded_for", null)
              x_forwarded_host  = lookup(headers.value, "x_forwarded_host", null)
            }
          }
        }
      }
      dynamic "scm_ip_restriction" {
        for_each = site_config.value.ip_restriction == null ? {} : site_config.value.ip_restriction
        content {
          name                      = scm_ip_restriction.key
          action                    = lookup(scm_ip_restriction.value, "action", null)
          ip_address                = lookup(scm_ip_restriction.value, "ip_address", null)
          priority                  = lookup(scm_ip_restriction.value, "priority", null)
          service_tag               = lookup(scm_ip_restriction.value, "service_tag", null)
          virtual_network_subnet_id = lookup(scm_ip_restriction.value, "virtual_network_subnet_id", null)
          dynamic "headers" {
            for_each = scm_ip_restriction.value.headers == null ? [] : [scm_ip_restriction.value.headers]
            content {
              x_azure_fdid      = lookup(headers.value, "x_azure_fdid", null)
              x_fd_health_probe = lookup(headers.value, "x_fd_health_probe", null)
              x_forwarded_for   = lookup(headers.value, "x_forwarded_for", null)
              x_forwarded_host  = lookup(headers.value, "x_forwarded_host", null)
            }
          }
        }
      }

      dynamic "virtual_application" {
        for_each = site_config.value.virtual_application == null ? [] : site_config.value.virtual_application
        content {
          physical_path = lookup(virtual_application.value, "physical_path")
          preload       = lookup(virtual_application.value, "preload")
          virtual_path  = lookup(virtual_application.value, "virtual_path")
        }
      }
 
      dynamic "application_stack" {
        for_each = site_config.value.application_stack == null ? [] : [site_config.value.application_stack]

        content {
          current_stack             = lookup(application_stack.value, "current_stack")
          docker_container_name     = lookup(application_stack.value, "docker_container_name")
          docker_container_registry = lookup(application_stack.value, "docker_container_registry")
          docker_container_tag      = lookup(application_stack.value, "docker_container_tag")
          dotnet_version            = lookup(application_stack.value, "dotnet_version")
          java_container            = lookup(application_stack.value, "java_container")
          java_container_version    = lookup(application_stack.value, "java_container_version")
          java_version              = lookup(application_stack.value, "java_version")
          node_version              = lookup(application_stack.value, "node_version")
          php_version               = lookup(application_stack.value, "php_version")
          python_version            = lookup(application_stack.value, "python_version")
        }
      }
    }
  }

  dynamic "identity" {
    for_each = each.value.identity == null ? [] : [each.value.identity]

    content {
      type         = lookup(identity.value, "type", null)
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }

  key_vault_reference_identity_id = each.value.key_vault_reference_identity_id

  dynamic "logs" {
    for_each = each.value.logs == null ? [] : [each.value.logs]

    content {
      detailed_error_messages = true
      failed_request_tracing = true
/*
      dynamic "application_logs" {
        for_each = logs.value.application_logs == null ? [] : [logs.value.application_logs]

        content {
          file_system_level = application_logs.value.file_system_level

          dynamic "azure_blob_storage" {
            for_each = application_logs.value.azure_blob_storage == null ? [] : [application_logs.value.azure_blob_storage]

            content {
              retention_in_days = azure_blob_storage.value.retention_in_days
             # sas_url = data.azurerm_storage_account_blob_container_sas.sas_url.sas
              level             = azure_blob_storage.value.level
            }
          }
        }

      }
      dynamic "http_logs" {
        for_each = logs.value.http_logs == null ? [] : [logs.value.http_logs]

        content {
          dynamic "azure_blob_storage" {
            for_each = http_logs.value.azure_blob_storage == null ? [] : [http_logs.value.azure_blob_storage]

            content {
              retention_in_days = azure_blob_storage.value.retention_in_days
            #  sas_url = data.azurerm_storage_account_blob_container_sas.sas_url.sas
            }
          }
        }
      }*/
    }
  }

  depends_on = [
    azurerm_service_plan.app_plans_main
  ]
}


resource "azurerm_windows_web_app_slot" "main" {
  for_each = var.app_windows_service_slots

  name    = each.value.name
  enabled = each.value.enabled   
  tags    = merge(var.default_tags, each.value.tags)
  app_service_id = (each.value.app_service_id != null ? each.value.app_service_id :
  [for k, v in azurerm_windows_web_app.app_windows_main : v.id if k == each.value.app_service_name][0])

  app_settings               = each.value.app_settings
  client_affinity_enabled    = each.value.client_affinity_enabled
  client_certificate_enabled = each.value.client_certificate_enabled
  client_certificate_mode    = each.value.client_certificate_mode
  https_only                 = each.value.https_only

  key_vault_reference_identity_id = each.value.key_vault_reference_identity_id

  dynamic "identity" {
    for_each = each.value.identity == null ? [] : [each.value.identity]

    content {
      type         = lookup(identity.value, "type", null)
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }

  dynamic "site_config" {
    for_each = each.value.site_config == null ? [] : [each.value.site_config]
    content {
      http2_enabled          = lookup(site_config.value, "http2_enabled", null)
      vnet_route_all_enabled = lookup(site_config.value, "vnet_route_all_enabled", null)
      always_on              = lookup(site_config.value, "always_on", null)
      app_command_line       = lookup(site_config.value, "app_command_line", null)
      health_check_path      = lookup(site_config.value, "health_check_path", null)
      ftps_state             = "FtpsOnly"
      minimum_tls_version               = "1.2"
      scm_minimum_tls_version           = "1.2"

      dynamic "virtual_application" {
        for_each = site_config.value.virtual_application == null ? [] : site_config.value.virtual_application
        content {
          physical_path = lookup(virtual_application.value, "physical_path")
          preload       = lookup(virtual_application.value, "preload")
          virtual_path  = lookup(virtual_application.value, "virtual_path")
        }
      }

      dynamic "application_stack" {
        for_each = site_config.value.application_stack == null ? [] : [site_config.value.application_stack]

        content {
          current_stack             = lookup(application_stack.value, "current_stack")
          docker_container_name     = lookup(application_stack.value, "docker_container_name")
          docker_container_registry = lookup(application_stack.value, "docker_container_registry")
          docker_container_tag      = lookup(application_stack.value, "docker_container_tag")
          dotnet_version            = lookup(application_stack.value, "dotnet_version")
          java_container            = lookup(application_stack.value, "java_container")
          java_container_version    = lookup(application_stack.value, "java_container_version")
          java_version              = lookup(application_stack.value, "java_version")
          node_version              = lookup(application_stack.value, "node_version")
          php_version               = lookup(application_stack.value, "php_version")
          python_version            = lookup(application_stack.value, "python_version")
        }
      }
    }
  }


  dynamic "logs" {
    for_each = each.value.logs == null ? [] : [each.value.logs]

    content {
      detailed_error_messages = true
      failed_request_tracing = true
/*
      dynamic "application_logs" {
        for_each = logs.value.application_logs == null ? [] : [logs.value.application_logs]

        content {
          file_system_level = application_logs.value.file_system_level

          dynamic "azure_blob_storage" {
            for_each = application_logs.value.azure_blob_storage == null ? [] : [application_logs.value.azure_blob_storage]

            content {
              retention_in_days = azure_blob_storage.value.retention_in_days
              sas_url = data.azurerm_storage_account_blob_container_sas.sas_url.sas
              level             = azure_blob_storage.value.level
            }
          }
        }

      }
      dynamic "http_logs" {
        for_each = logs.value.http_logs == null ? [] : [logs.value.http_logs]

        content {
          dynamic "azure_blob_storage" {
            for_each = http_logs.value.azure_blob_storage == null ? [] : [http_logs.value.azure_blob_storage]

            content {
              retention_in_days = azure_blob_storage.value.retention_in_days
              sas_url = data.azurerm_storage_account_blob_container_sas.sas_url.sas
            }
          }
        }
      }*/
    }
  }
}

resource "azurerm_app_service_slot_virtual_network_swift_connection" "service_slot_vnet_integretion" {
  for_each = var.app_service_slot_vnet_integretion

  slot_name = each.value.slot_name
  app_service_id = (
    [for k, v in azurerm_windows_web_app.app_windows_main : v.id if v.name == each.value.app_service_name] != [] ?
    [for k, v in azurerm_windows_web_app.app_windows_main : v.id if v.name == each.value.app_service_name][0] : null
  )

  subnet_id = (each.value.subnet_id != null ? each.value.subnet_id :
    [for k, v in data.azurerm_subnet.for_integration_subnet_data : v.id if v.name == each.value.subnet_name &&
      v.virtual_network_name == each.value.vnet_name &&
  v.resource_group_name == each.value.subnet_resource_group][0])

  depends_on = [
    azurerm_windows_web_app_slot.main,
    azurerm_app_service_virtual_network_swift_connection.vnet_integretion
  ]
}


resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integretion" {
  for_each = var.app_service_vnet_integretion
  app_service_id = (
    [for k, v in azurerm_windows_web_app.app_windows_main : v.id if v.name == each.key] != [] ?
    [for k, v in azurerm_windows_web_app.app_windows_main : v.id if v.name == each.key][0] : null
  )

  subnet_id = (each.value.subnet_id != null ? each.value.subnet_id :
    [for k, v in data.azurerm_subnet.for_integration_subnet_data : v.id if v.name == each.value.subnet_name &&
      v.virtual_network_name == each.value.vnet_name &&
  v.resource_group_name == each.value.subnet_resource_group][0])
}