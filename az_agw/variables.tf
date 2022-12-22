variable "default_tags" {
  type    = map(string)
  default = {}
}

variable "az_application_gateways" {
  type = map(object({
    resource_group_name = string
    location            = string
    tags                = map(string) # Must provide tags = {} if not set.
    zones               = optional(set(string))
    enable_http2        = optional(bool)

    sku = object({
      #Possible values are Standard_Small, Standard_Medium, Standard_Large, Standard_v2, WAF_Medium, WAF_Large, and WAF_v2.
      name = string
      #The Tier of the SKU to use for this Application Gateway. Possible values are Standard, Standard_v2, WAF and WAF_v2.
      tier = string
      #The Capacity of the SKU to use for this Application Gateway. When using a V1 SKU this value must be between 1 and 32, and 1 to 125 for a V2 SKU. This property is optional if autoscale_configuration is set.
      capacity = optional(number)
    })

    identity = optional(object({
      type         = optional(string)
      identity_ids = set(string)
    }))

    autoscale_configuration = optional(object({
      min_capacity = number
      max_capacity = optional(number)
    }))

    trusted_client_certificates = optional(map(object({
      # name is key

      # Base-64 Encoded
      data = string
    })))

    trusted_root_certificates = optional(map(object({
      # name is key

      # Base-64 Encoded
      data = optional(string)
      #(Optional) The Secret ID of (base-64 encoded unencrypted pfx) Secret or Certificate object stored in Azure KeyVault. You need to enable soft delete for the Key Vault to use this feature. Required if data is not set.
      key_vault_secret_id = optional(string)
    })))

    ssl_certificates = optional(map(object({
      # name is key

      #(Optional) PFX certificate. Required if key_vault_secret_id is not set.
      data = optional(string)
      #(Optional) Password for the pfx file specified in data. Required if data is set.
      password = optional(string)

      #(Optional) Secret Id of (base-64 encoded unencrypted pfx) Secret or Certificate object stored in Azure KeyVault. You need to enable soft delete for keyvault to use this feature. Required if data is not set.
      key_vault_secret_id = optional(string)
    })))

    ssl_policy = optional(object({
      #The Name of the Policy e.g AppGwSslPolicy20170401S. Required if policy_type is set to Predefined. 
      #Possible values can change over time and are published 
      #here https://docs.microsoft.com/azure/application-gateway/application-gateway-ssl-policy-overview. 
      #Not compatible with disabled_protocols.
      policy_name = optional(string)

      policy_type          = optional(string) #Possible values are Predefined and Custom.
      disabled_protocols   = optional(set(string))
      min_protocol_version = optional(string) # The minimal TLS version. Possible values are TLSv1_0, TLSv1_1 and TLSv1_2.

      # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway#cipher_suites
      cipher_suites = optional(set(string))
    }))


    authentication_certificates = optional(map(object({
      data = string
    })))

    backend_http_settings = map(object({
      # (Required) Is Cookie-Based Affinity enabled? Possible values are Enabled and Disabled.
      cookie_based_affinity = string

      # (Optional) The name of the affinity cookie.
      affinity_cookie_name = optional(string)

      # (Optional) The Path which should be used as a prefix for all HTTP requests.
      path = optional(string)

      # (Required) The port which should be used for this Backend HTTP Settings Collection.
      port = number

      # (Optional) The name of an associated HTTP Probe.
      probe_name = optional(string)

      # (Required) The Protocol which should be used. Possible values are Http and Https.
      protocol = string

      # (Required) The request timeout in seconds, which must be between 1 and 86400 seconds.
      request_timeout = number

      # (Optional) Host header to be sent to the backend servers. Cannot be set if pick_host_name_from_backend_address is set to true.
      host_name = optional(string)

      # (Optional) Whether host header should be picked from the host name of the backend server. Defaults to false.
      pick_host_name_from_backend_address = optional(bool)

      authentication_certificate = optional(object({
        # key is the name of auth cert 
        # (Required) The Name of the Authentication Certificate to use.
      }))

      # (Optional) A list of trusted_root_certificate names.
      trusted_root_certificate_names = optional(set(string))

      connection_draining = optional(object({
        enabled           = bool
        drain_timeout_sec = number
      }))

    }))

    gateway_ip_configuration = map(object({
      subnet_id                = optional(string)
      subnet_name              = optional(string)
      vnet_name                = optional(string)
      vnet_resource_group_name = optional(string)
    }))

    frontend_ip_configuration = map(object({
      # key is the name configuration

      subnet_id                       = optional(string)
      private_ip_address              = optional(string)
      private_ip_address_allocation   = optional(string)
      private_link_configuration_name = optional(string)

      public_ip_address_id  = optional(string) # Turn off auto_create_public_ip if you want to use exist public_ip
      auto_create_public_ip = optional(bool)   # Custom parameter, set to true if you want to auto create a public ip
      public_ip_spec = optional(object({       # Need this when auto_create_public_ip is enable.
        sku                     = optional(string)
        sku_tier                = optional(string)
        edge_zone               = optional(string)
        allocation_method       = optional(string)
        edge_zone               = optional(string)
        domain_name_label       = optional(string)
        idle_timeout_in_minutes = optional(number)
        ip_version              = optional(string)
        ip_tags                 = optional(map(string))
      }))
    }))

    probes = optional(map(object({
      host                                      = optional(string)
      interval                                  = number
      protocol                                  = string
      path                                      = string
      unhealthy_threshold                       = number
      port                                      = optional(number)
      pick_host_name_from_backend_http_settings = optional(bool)
      minimum_servers                           = optional(number)
      timeout                                   = number
      match = optional(object({
        body        = string
        status_code = set(number)
      }))
    })))

    http_listeners = map(object({
      frontend_ip_configuration_name = optional(string)
      frontend_port_name             = optional(string)
      host_name                      = optional(string)
      host_names                     = optional(set(string))
      protocol                       = optional(string)
      require_sni                    = optional(bool)
      ssl_certificate_name           = optional(string)

      firewall_policy_id = optional(string)
      ssl_profile_name   = optional(string)

      custom_error_configuration = optional(map(object({
        status_code           = string
        custom_error_page_url = string
      })))
    }))

    identity = optional(object({
      type         = string
      identity_ids = set(string)
    }))

    fips_enabled = optional(bool)

    frontend_ports = map(object({
      port = number
    }))

    request_routing_rules = map(object({
      rule_type                   = string
      http_listener_name          = string
      backend_address_pool_name   = optional(string)
      backend_http_settings_name  = optional(string)
      redirect_configuration_name = optional(string)
      rewrite_rule_set_name       = optional(string)
      url_path_map_name           = optional(string)
      priority                    = optional(number)
    }))

    backend_address_pools = map(object({
      fqdns        = optional(set(string))
      ip_addresses = optional(set(string))
    }))

    waf_configuration = optional(object({
      enabled                  = bool
      firewall_mode            = string           #Possible values are Detection and Prevention.
      rule_set_type            = string           #The Type of the Rule Set used for this Web Application Firewall. Currently, only OWASP is supported.
      rule_set_version         = string           #Possible values are 2.2.9, 3.0, 3.1, and 3.2.
      file_upload_limit_mb     = optional(number) #Accepted values are in the range 1MB to 750MB for the WAF_v2 SKU, and 1MB to 500MB for all other SKUs. Defaults to 100MB.
      request_body_check       = optional(bool)   #Is Request Body Inspection enabled? Defaults to true.
      max_request_body_size_kb = optional(number) #Accepted values are in the range 1KB to 128KB. Defaults to 128KB.

      disabled_rule_group = optional(map(object({
        #rule_group_name is the key
        rules = optional(set(string)) #A list of rules which should be disabled in that group. Disables all rules in the specified group if rules is not specified.
      })))

      exclusion = optional(map(object({
        #match_variable is the key which has possible values are RequestHeaderNames, RequestArgNames and RequestCookieNames
        selector_match_operator = optional(string) #Operator which will be used to search in the variable content. Possible values are Equals, StartsWith, EndsWith, Contains. If empty will exclude all traffic on this match_variable
        selector                = optional(string) # String value which will be used for the filter operation. If empty will exclude all traffic on this match_variable
      })))
    }))

    rewrite_rule_set = optional(map(object({
      #rewrite_rule_set_name is the key
      rewrite_rule = map(object({
        #rewrite_rule_name is the key
        rule_sequence = number
        condition = optional(list(object({
          variable    = string
          pattern     = string
          ignore_case = optional(bool)
          negate      = optional(bool)
        })))

        request_header_configuration = optional(list(object({
          header_name  = string
          header_value = string
        })))

        response_header_configuration = optional(list(object({
          header_name  = string
          header_value = string
        })))

        url = optional(object({
          path         = optional(string)
          query_string = optional(string)
          reroute      = optional(bool)
        }))

      }))
    })))

    url_path_maps = optional(map(object({
      #Name is the key
      default_backend_address_pool_name   = optional(string)
      default_backend_http_settings_name  = optional(string)
      default_redirect_configuration_name = optional(string)
      default_rewrite_rule_set_name       = optional(string)
      path_rule = map(object({
        paths                       = set(string)
        backend_address_pool_name   = optional(string)
        backend_http_settings_name  = optional(string)
        rewrite_rule_set_name       = optional(string)
        redirect_configuration_name = optional(string)
      }))
    })))

    redirect_configurations = optional(map(object({
      #Name is the key

      #The type of redirect. Possible values are Permanent, Temporary, Found and SeeOther
      redirect_type = string

      #The name of the listener to redirect to. Cannot be set if target_url is set.
      target_listener_name = optional(string)

      #The Url to redirect the request to. Cannot be set if target_listener_name is set.
      target_url = optional(string)

      include_path         = optional(bool)
      include_query_string = optional(bool)
    })))

  }))
  default = {}
}
