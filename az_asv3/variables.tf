variable "default_tags" {
  type    = map(string)
  default = {}
}

variable "app_service_resource_group_name" {
  type        = string
  default     = null
  description = "Default Resource Group"
}

variable "app_service_location" {
  type        = string
  default     = null
  description = "Default Location"
}

variable "action_group_id" {
  type        = string
  default     = null
}

variable "alerts_dev" {
  type = map(object({
    name                = optional(string)
    resource_group_name = optional(string)
    scopes              = optional(string)
    description         = optional(string)
    frequency           = optional(string)
    window_size         = optional(string) 
    severity            = optional(string) 
    criteria            = map(string)
  }))
  default = {}
}
variable "activitylog_alerts_dev" {
  type = map(object({
    name                = optional(string)
    resource_group_name = optional(string)
    scopes              = optional(string)
    description         = optional(string)
    criteria            = map(string)
  }))
  default = {}
}

variable "app_services_environment_v3" {
  type = map(object({
    resource_group_name = string

    subnet_name         = string
    vnet_name           = string
    vnet_resource_group = string

    internal_load_balancing_mode           = string
    allow_new_private_endpoint_connections = bool
    zone_redundant                         = bool
    cluster_setting                        = map(string)
    tags                                   = map(string)
  }))
  default = {}
}

variable "app_services_plan" {
  type = map(object({
    os_type                  = string
    sku_name                 = string
    app_service_env_v3_name  = optional(string)
    worker_count             = optional(number)
    per_site_scaling_enabled = optional(bool)
    tags                     = map(string)
  }))
  default = {}
}


variable "logs_storage_account_name" {
  default = {}
}
 
variable "logs_container_name" {
  default = {}
}

variable "logs_storage_resource_group_name" {
  default = {}
}


variable "app_windows_services" {
  type = map(object({
    app_service_plan_name   = string
    resource_group_name     = optional(string)
    client_affinity_enabled = optional(bool)
    client_certificate_enabled = optional(bool)
    https_only              = optional(bool)
    auth_settings = object({
      enabled                        = optional(bool)
      additional_login_params        = optional(map(string))
      allowed_external_redirect_urls = optional(list(string))
      default_provider               = optional(string)
      issuer                         = optional(string)
      runtime_version                = optional(string)
      token_refresh_extension_hours  = optional(number)
      token_store_enabled            = optional(bool)
      unauthenticated_client_action  = optional(string)
    })

    site_config = optional(object({
      http2_enabled          = optional(bool)
      vnet_route_all_enabled = optional(bool)
      always_on              = optional(bool)
      app_command_line       = optional(string)
      health_check_path      = optional(string)
      ftps_state             = optional(string)

      default_documents                 = optional(set(string))
      health_check_eviction_time_in_min = optional(number)
      load_balancing_mode               = optional(string)
      local_mysql_enabled               = optional(bool)
      managed_pipeline_mode             = optional(string)
      minimum_tls_version               = optional(string)
      remote_debugging_enabled          = optional(bool)
      remote_debugging_version          = optional(string)
      scm_minimum_tls_version           = optional(string)
      scm_use_main_ip_restriction       = optional(bool)
      use_32_bit_worker                 = optional(bool)
      websockets_enabled                = optional(bool)
      worker_count                      = optional(number)

      ip_restriction = optional(map(object({
        # name is the key
        action                    = optional(string) # Allow or Deny
        ip_address                = optional(string) # For example: 10.0.0.0/24 or 192.168.10.1/32
        priority                  = optional(number)
        service_tag               = optional(string)
        virtual_network_subnet_id = optional(string)
        headers = optional(object({
          x_azure_fdid      = optional(string)
          x_fd_health_probe = optional(string)
          x_forwarded_for   = optional(string)
          x_forwarded_host  = optional(string)
        }))
      })))

      scm_ip_restriction = optional(map(object({
        # name is the key
        action                    = optional(string) # Allow or Deny
        ip_address                = optional(string) # For example: 10.0.0.0/24 or 192.168.10.1/32
        priority                  = optional(number)
        service_tag               = optional(string)
        virtual_network_subnet_id = optional(string)
        headers = optional(object({
          x_azure_fdid      = optional(string)
          x_fd_health_probe = optional(string)
          x_forwarded_for   = optional(string)
          x_forwarded_host  = optional(string)
        }))
      })))
 
      application_stack = optional(object({
        current_stack             = optional(string)
        docker_container_name     = optional(string)
        docker_container_registry = optional(string)
        docker_container_tag      = optional(string)
        dotnet_version            = optional(string)
        java_container            = optional(string)
        java_container_version    = optional(string)
        java_version              = optional(string)
        node_version              = optional(string)
        php_version               = optional(string)
        python_version            = optional(string)
      }))

      virtual_application = optional(list(object({
        physical_path = optional(string)
        preload       = optional(bool)
        virtual_path  = optional(string)
      })))

    }))
    connection_string = optional(object({
      name             = optional(string)
      type             = optional(string)
      value            = optional(string)
    }))
    app_settings = optional(map(string))
    sticky_settings = optional(object({
      app_setting_names       = optional(set(string))
      connection_string_names = optional(set(string))
    }))

    identity = optional(object({
      type         = string
      identity_ids = set(string)
    }))

    key_vault_reference_identity_id = optional(string)

    logs = optional(object({
      detailed_error_messages_enabled = optional(bool)
      failed_request_tracing_enabled  = optional(bool)

      application_logs = optional(object({
        file_system_level = optional(string)
        azure_blob_storage = optional(object({
          retention_in_days = number
          sas_url           = optional(string)
          level             = string
        }))
      }))

      http_logs = optional(object({
        azure_blob_storage = optional(object({
          retention_in_days = number
          sas_url           = optional(string)
          level             = string
        }))
      }))
    }))

    tags = map(string)
  }))
  default = {}
}

variable "app_windows_service_slots" {
  type = map(object({
    name             = optional(string)
    enabled          = optional(bool)
    app_service_name = optional(string)
    app_service_id   = optional(string)

    app_settings               = optional(map(string))
    client_affinity_enabled    = optional(bool)
    client_certificate_enabled = optional(bool)
    client_certificate_mode    = optional(string)
    https_only                 = optional(bool)
    auth_settings = object({
      enabled                        = optional(bool)
      additional_login_params        = optional(map(string))
      allowed_external_redirect_urls = optional(list(string))
      default_provider               = optional(string)
      issuer                         = optional(string)
      runtime_version                = optional(string)
      token_refresh_extension_hours  = optional(number)
      token_store_enabled            = optional(bool)
      unauthenticated_client_action  = optional(string)
    })
    storage_accounts = optional(list(object({
      name         = optional(string)
      type         = optional(string)
      account_name = optional(string)
      share_name   = optional(string)
      access_key   = optional(string)
      mount_path   = optional(string)
    })))

    key_vault_reference_identity_id = optional(string)

    site_config = optional(object({
      http2_enabled          = optional(bool)
      vnet_route_all_enabled = optional(bool)
      always_on              = optional(bool)
      app_command_line       = optional(string)
      health_check_path      = optional(string)
      ftps_state             = optional(string)

      application_stack = optional(object({
        current_stack             = optional(string)
        docker_container_name     = optional(string)
        docker_container_registry = optional(string)
        docker_container_tag      = optional(string)
        dotnet_version            = optional(string)
        java_container            = optional(string)
        java_container_version    = optional(string)
        java_version              = optional(string)
        node_version              = optional(string)
        php_version               = optional(string)
        python_version            = optional(string)
      }))

      virtual_application = optional(list(object({
        physical_path = optional(string)
        preload       = optional(bool)
        virtual_path  = optional(string)
      })))

    }))

    logs = optional(object({
      detailed_error_messages_enabled = optional(bool)
      failed_request_tracing_enabled  = optional(bool)

      application_logs = optional(object({
        file_system_level = optional(string)
        azure_blob_storage = optional(object({
          retention_in_days = number
          sas_url           = optional(string)
          level             = string
        }))
      }))

      http_logs = optional(object({
        azure_blob_storage = optional(object({
          retention_in_days = number
          sas_url           = optional(string)
          level             = string
        }))
      }))
    }))


    identity = optional(object({
      type         = string
      identity_ids = set(string)
    }))

    tags = map(string)
  }))
  default = {}
}


variable "app_service_slot_vnet_integretion" {
  type = map(object({
    slot_name             = string
    app_service_name      = string
    subnet_name           = optional(string)
    subnet_resource_group = optional(string)
    vnet_name             = optional(string)

    subnet_id = optional(string)
  }))

  default = {}
}

variable "app_service_vnet_integretion" {
  type = map(object({

    subnet_name           = optional(string)
    subnet_resource_group = optional(string)
    vnet_name             = optional(string)

    subnet_id = optional(string)
  }))

  default = {}
}