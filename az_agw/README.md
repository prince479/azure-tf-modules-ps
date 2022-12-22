# AZ Application Gateway

<https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway>

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_application_gateway.app_gws](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway) | resource |
| [azurerm_public_ip.pip_agw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_subnet.subnet_gw_ip_conf](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_az_application_gateways"></a> [az\_application\_gateways](#input\_az\_application\_gateways) | n/a | <pre>map(object({<br>    resource_group_name = string<br>    location            = string<br>    tags                = map(string) # Must provide tags = {} if not set.<br>    zones               = optional(set(string))<br>    enable_http2        = optional(bool)<br><br>    sku = object({<br>      #Possible values are Standard_Small, Standard_Medium, Standard_Large, Standard_v2, WAF_Medium, WAF_Large, and WAF_v2.<br>      name = string<br>      #The Tier of the SKU to use for this Application Gateway. Possible values are Standard, Standard_v2, WAF and WAF_v2.<br>      tier = string<br>      #The Capacity of the SKU to use for this Application Gateway. When using a V1 SKU this value must be between 1 and 32, and 1 to 125 for a V2 SKU. This property is optional if autoscale_configuration is set.<br>      capacity = optional(number)<br>    })<br><br>    identity = optional(object({<br>      type         = optional(string)<br>      identity_ids = set(string)<br>    }))<br><br>    autoscale_configuration = optional(object({<br>      min_capacity = number<br>      max_capacity = optional(number)<br>    }))<br><br>    trusted_client_certificates = optional(map(object({<br>      # name is key<br><br>      # Base-64 Encoded<br>      data = string<br>    })))<br><br>    trusted_root_certificates = optional(map(object({<br>      # name is key<br><br>      # Base-64 Encoded<br>      data = optional(string)<br>      #(Optional) The Secret ID of (base-64 encoded unencrypted pfx) Secret or Certificate object stored in Azure KeyVault. You need to enable soft delete for the Key Vault to use this feature. Required if data is not set.<br>      key_vault_secret_id = optional(string)<br>    })))<br><br>    ssl_certificates = optional(map(object({<br>      # name is key<br><br>      #(Optional) PFX certificate. Required if key_vault_secret_id is not set.<br>      data = optional(string)<br>      #(Optional) Password for the pfx file specified in data. Required if data is set.<br>      password = optional(string)<br><br>      #(Optional) Secret Id of (base-64 encoded unencrypted pfx) Secret or Certificate object stored in Azure KeyVault. You need to enable soft delete for keyvault to use this feature. Required if data is not set.<br>      key_vault_secret_id = optional(string)<br>    })))<br><br>    ssl_policy = optional(object({<br>      #The Name of the Policy e.g AppGwSslPolicy20170401S. Required if policy_type is set to Predefined. <br>      #Possible values can change over time and are published <br>      #here https://docs.microsoft.com/azure/application-gateway/application-gateway-ssl-policy-overview. <br>      #Not compatible with disabled_protocols.<br>      policy_name = optional(string)<br><br>      policy_type          = optional(string) #Possible values are Predefined and Custom.<br>      disabled_protocols   = optional(set(string))<br>      min_protocol_version = optional(string) # The minimal TLS version. Possible values are TLSv1_0, TLSv1_1 and TLSv1_2.<br><br>      # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway#cipher_suites<br>      cipher_suites = optional(set(string))<br>    }))<br><br><br>    authentication_certificates = optional(map(object({<br>      data = string<br>    })))<br><br>    backend_http_settings = map(object({<br>      # (Required) Is Cookie-Based Affinity enabled? Possible values are Enabled and Disabled.<br>      cookie_based_affinity = string<br><br>      # (Optional) The name of the affinity cookie.<br>      affinity_cookie_name = optional(string)<br><br>      # (Optional) The Path which should be used as a prefix for all HTTP requests.<br>      path = optional(string)<br><br>      # (Required) The port which should be used for this Backend HTTP Settings Collection.<br>      port = number<br><br>      # (Optional) The name of an associated HTTP Probe.<br>      probe_name = optional(string)<br><br>      # (Required) The Protocol which should be used. Possible values are Http and Https.<br>      protocol = string<br><br>      # (Required) The request timeout in seconds, which must be between 1 and 86400 seconds.<br>      request_timeout = number<br><br>      # (Optional) Host header to be sent to the backend servers. Cannot be set if pick_host_name_from_backend_address is set to true.<br>      host_name = optional(string)<br><br>      # (Optional) Whether host header should be picked from the host name of the backend server. Defaults to false.<br>      pick_host_name_from_backend_address = optional(bool)<br><br>      authentication_certificate = optional(object({<br>        # key is the name of auth cert <br>        # (Required) The Name of the Authentication Certificate to use.<br>      }))<br><br>      # (Optional) A list of trusted_root_certificate names.<br>      trusted_root_certificate_names = optional(set(string))<br><br>      connection_draining = optional(object({<br>        enabled           = bool<br>        drain_timeout_sec = number<br>      }))<br><br>    }))<br><br>    gateway_ip_configuration = map(object({<br>      subnet_id                = optional(string)<br>      subnet_name              = optional(string)<br>      vnet_name                = optional(string)<br>      vnet_resource_group_name = optional(string)<br>    }))<br><br>    frontend_ip_configuration = map(object({<br>      # key is the name configuration<br><br>      subnet_id                       = optional(string)<br>      private_ip_address              = optional(string)<br>      private_ip_address_allocation   = optional(string)<br>      private_link_configuration_name = optional(string)<br><br>      public_ip_address_id  = optional(string) # Turn off auto_create_public_ip if you want to use exist public_ip<br>      auto_create_public_ip = optional(bool)   # Custom parameter, set to true if you want to auto create a public ip<br>      public_ip_spec = optional(object({       # Need this when auto_create_public_ip is enable.<br>        sku                     = optional(string)<br>        sku_tier                = optional(string)<br>        edge_zone               = optional(string)<br>        allocation_method       = optional(string)<br>        edge_zone               = optional(string)<br>        domain_name_label       = optional(string)<br>        idle_timeout_in_minutes = optional(number)<br>        ip_version              = optional(string)<br>        ip_tags                 = optional(map(string))<br>      }))<br>    }))<br><br>    probes = optional(map(object({<br>      host                                      = optional(string)<br>      interval                                  = number<br>      protocol                                  = string<br>      path                                      = string<br>      unhealthy_threshold                       = number<br>      port                                      = optional(number)<br>      pick_host_name_from_backend_http_settings = optional(bool)<br>      minimum_servers                           = optional(number)<br>      timeout                                   = number<br>      match = optional(object({<br>        body        = string<br>        status_code = set(number)<br>      }))<br>    })))<br><br>    http_listeners = map(object({<br>      frontend_ip_configuration_name = optional(string)<br>      frontend_port_name             = optional(string)<br>      host_name                      = optional(string)<br>      host_names                     = optional(set(string))<br>      protocol                       = optional(string)<br>      require_sni                    = optional(bool)<br>      ssl_certificate_name           = optional(string)<br><br>      firewall_policy_id = optional(string)<br>      ssl_profile_name   = optional(string)<br><br>      custom_error_configuration = optional(map(object({<br>        status_code           = string<br>        custom_error_page_url = string<br>      })))<br>    }))<br><br>    identity = optional(object({<br>      type         = string<br>      identity_ids = set(string)<br>    }))<br><br>    fips_enabled = optional(bool)<br><br>    frontend_ports = map(object({<br>      port = number<br>    }))<br><br>    request_routing_rules = map(object({<br>      rule_type                   = string<br>      http_listener_name          = string<br>      backend_address_pool_name   = optional(string)<br>      backend_http_settings_name  = optional(string)<br>      redirect_configuration_name = optional(string)<br>      rewrite_rule_set_name       = optional(string)<br>      url_path_map_name           = optional(string)<br>      priority                    = optional(number)<br>    }))<br><br>    backend_address_pools = map(object({<br>      fqdns        = optional(set(string))<br>      ip_addresses = optional(set(string))<br>    }))<br><br>    waf_configuration = optional(object({<br>      enabled                  = bool<br>      firewall_mode            = string           #Possible values are Detection and Prevention.<br>      rule_set_type            = string           #The Type of the Rule Set used for this Web Application Firewall. Currently, only OWASP is supported.<br>      rule_set_version         = string           #Possible values are 2.2.9, 3.0, 3.1, and 3.2.<br>      file_upload_limit_mb     = optional(number) #Accepted values are in the range 1MB to 750MB for the WAF_v2 SKU, and 1MB to 500MB for all other SKUs. Defaults to 100MB.<br>      request_body_check       = optional(bool)   #Is Request Body Inspection enabled? Defaults to true.<br>      max_request_body_size_kb = optional(number) #Accepted values are in the range 1KB to 128KB. Defaults to 128KB.<br><br>      disabled_rule_group = optional(map(object({<br>        #rule_group_name is the key<br>        rules = optional(set(string)) #A list of rules which should be disabled in that group. Disables all rules in the specified group if rules is not specified.<br>      })))<br><br>      exclusion = optional(map(object({<br>        #match_variable is the key which has possible values are RequestHeaderNames, RequestArgNames and RequestCookieNames<br>        selector_match_operator = optional(string) #Operator which will be used to search in the variable content. Possible values are Equals, StartsWith, EndsWith, Contains. If empty will exclude all traffic on this match_variable<br>        selector                = optional(string) # String value which will be used for the filter operation. If empty will exclude all traffic on this match_variable<br>      })))<br>    }))<br><br>    rewrite_rule_set = optional(map(object({<br>      #rewrite_rule_set_name is the key<br>      rewrite_rule = map(object({<br>        #rewrite_rule_name is the key<br>        rule_sequence = number<br>        condition = optional(list(object({<br>          variable    = string<br>          pattern     = string<br>          ignore_case = optional(bool)<br>          negate      = optional(bool)<br>        })))<br><br>        request_header_configuration = optional(list(object({<br>          header_name  = string<br>          header_value = string<br>        })))<br><br>        response_header_configuration = optional(list(object({<br>          header_name  = string<br>          header_value = string<br>        })))<br><br>        url = optional(object({<br>          path         = optional(string)<br>          query_string = optional(string)<br>          reroute      = optional(bool)<br>        }))<br><br>      }))<br>    })))<br><br>    url_path_maps = optional(map(object({<br>      #Name is the key<br>      default_backend_address_pool_name   = optional(string)<br>      default_backend_http_settings_name  = optional(string)<br>      default_redirect_configuration_name = optional(string)<br>      default_rewrite_rule_set_name       = optional(string)<br>      path_rule = map(object({<br>        paths                       = set(string)<br>        backend_address_pool_name   = optional(string)<br>        backend_http_settings_name  = optional(string)<br>        rewrite_rule_set_name       = optional(string)<br>        redirect_configuration_name = optional(string)<br>      }))<br>    })))<br><br>    redirect_configurations = optional(map(object({<br>      #Name is the key<br><br>      #The type of redirect. Possible values are Permanent, Temporary, Found and SeeOther<br>      redirect_type = string<br><br>      #The name of the listener to redirect to. Cannot be set if target_url is set.<br>      target_listener_name = optional(string)<br><br>      #The Url to redirect the request to. Cannot be set if target_listener_name is set.<br>      target_url = optional(string)<br><br>      include_path         = optional(bool)<br>      include_query_string = optional(bool)<br>    })))<br><br>  }))</pre> | `{}` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | n/a | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->