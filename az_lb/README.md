# az_lb

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
| [azurerm_lb.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb) | resource |
| [azurerm_lb_backend_address_pool.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool) | resource |
| [azurerm_lb_nat_pool.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_nat_pool) | resource |
| [azurerm_lb_nat_rule.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_nat_rule) | resource |
| [azurerm_lb_probe.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe) | resource |
| [azurerm_lb_rule.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) | resource |
| [azurerm_subnet.subnet_for_frontend_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_az_lb"></a> [az\_lb](#input\_az\_lb) | n/a | <pre>map(object({<br>    location            = optional(string)<br>    resource_group_name = optional(string)<br>    edge_zone           = optional(string)<br>    sku                 = optional(string) # Basic, Standard and Gateway. Defaults to Basic.<br>    sku_tier            = optional(string) # Global and Regional. Defaults to Regional<br>    tags                = optional(map(string))<br><br>    # Key as the name of frontend_ip_configuration Defaults to Zone-Redundant<br>    frontend_ip_configuration = optional(map(object({<br>      availability_zone                                  = optional(set(string))<br>      subnet_id                                          = optional(string)<br>      vnet_name                                          = optional(string)<br>      subnet_name                                        = optional(string)<br>      vnet_resource_group_name                           = optional(string)<br>      gateway_load_balancer_frontend_ip_configuration_id = optional(string)<br>      private_ip_address                                 = optional(string)<br><br>      #Dynamic and Static<br>      private_ip_address_allocation = optional(string)<br>      # IPv4 or IPv6<br>      private_ip_address_version = optional(string)<br>      public_ip_address_id       = optional(string)<br>      public_ip_prefix_id        = optional(string)<br>    })))<br><br>    backend_address_pool = optional(map(object({<br>      tunnel_interface = optional(map(object({<br>        identifier = string<br><br>        # Internal and External<br>        type = string<br><br>        # Native and VXLAN<br>        protocol = string<br>        port     = number<br>      })))<br>    })))<br><br>  }))</pre> | `{}` | no |
| <a name="input_az_lb_backend_address_pool"></a> [az\_lb\_backend\_address\_pool](#input\_az\_lb\_backend\_address\_pool) | n/a | <pre>map(object({<br>    loadbalancer_name = optional(string) # Support only LB which created in this module.<br>    loadbalancer_id   = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_az_lb_nat_pool"></a> [az\_lb\_nat\_pool](#input\_az\_lb\_nat\_pool) | n/a | <pre>map(object({<br>    loadbalancer_name              = optional(string) # Support only LB which created in this module.<br>    loadbalancer_id                = optional(string)<br>    frontend_ip_configuration_name = string<br>    resource_group_name            = optional(string)<br><br>    backend_port      = number<br>    protocol          = string<br>    tcp_reset_enabled = optional(bool)<br><br>    frontend_port_start = number<br>    frontend_port_end   = number<br><br>    floating_ip_enabled = optional(bool)<br>  }))</pre> | `{}` | no |
| <a name="input_az_lb_nat_rule"></a> [az\_lb\_nat\_rule](#input\_az\_lb\_nat\_rule) | n/a | <pre>map(object({<br>    resource_group_name = optional(string)<br>    loadbalancer_name   = optional(string) # Support only LB which created in this module.<br>    loadbalancer_id     = optional(string)<br><br>    frontend_ip_configuration_name = string<br>    protocol                       = string<br>    frontend_port                  = number<br>    backend_port                   = number<br><br>    idle_timeout_in_minutes = optional(number)<br>    enable_floating_ip      = optional(string)<br>    enable_tcp_reset        = optional(bool)<br>  }))</pre> | n/a | yes |
| <a name="input_az_lb_probe"></a> [az\_lb\_probe](#input\_az\_lb\_probe) | n/a | <pre>map(object({<br>    loadbalancer_id   = optional(string)<br>    loadbalancer_name = optional(string)<br>    protocol          = string<br>    port              = string<br><br>    request_path        = optional(string)<br>    interval_in_seconds = optional(string)<br>    number_of_probes    = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_az_lb_rule"></a> [az\_lb\_rule](#input\_az\_lb\_rule) | n/a | <pre>map(object({<br>    loadbalancer_id                = optional(string)<br>    loadbalancer_name              = optional(string)<br>    protocol                       = string<br>    frontend_port                  = number<br>    backend_port                   = number<br>    frontend_ip_configuration_name = string<br><br>    backend_address_pool_ids   = optional(set(string))<br>    backend_address_pool_names = optional(set(string))<br><br>    probe_id   = optional(string)<br>    probe_name = optional(string)<br><br>    enable_floating_ip      = optional(bool)<br>    idle_timeout_in_minutes = optional(number)<br>    load_distribution       = optional(string) # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule#load_distribution<br>    disable_outbound_snat   = optional(bool)<br>    enable_tcp_reset        = optional(bool)<br>  }))</pre> | `{}` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lb_backend_pool_results"></a> [lb\_backend\_pool\_results](#output\_lb\_backend\_pool\_results) | n/a |
| <a name="output_lb_results"></a> [lb\_results](#output\_lb\_results) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
