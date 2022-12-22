variable "resource_group_name" {
  type    = string
  default = null
}
variable "location" {
  type    = string
  default = null
}

variable "default_tags" {
  type    = map(string)
  default = {}
}

variable "az_lb" {
  type = map(object({
    location            = optional(string)
    resource_group_name = optional(string)
    edge_zone           = optional(string)
    sku                 = optional(string) # Basic, Standard and Gateway. Defaults to Basic.
    sku_tier            = optional(string) # Global and Regional. Defaults to Regional
    tags                = optional(map(string))

    # Key as the name of frontend_ip_configuration Defaults to Zone-Redundant
    frontend_ip_configuration = optional(map(object({
      availability_zone                                  = optional(set(string))
      subnet_id                                          = optional(string)
      vnet_name                                          = optional(string)
      subnet_name                                        = optional(string)
      vnet_resource_group_name                           = optional(string)
      gateway_load_balancer_frontend_ip_configuration_id = optional(string)
      private_ip_address                                 = optional(string)

      #Dynamic and Static
      private_ip_address_allocation = optional(string)
      # IPv4 or IPv6
      private_ip_address_version = optional(string)
      public_ip_address_id       = optional(string)
      public_ip_prefix_id        = optional(string)
    })))

    backend_address_pool = optional(map(object({
      tunnel_interface = optional(map(object({
        identifier = string

        # Internal and External
        type = string

        # Native and VXLAN
        protocol = string
        port     = number
      })))
    })))

  }))
  default = {}
}

variable "az_lb_backend_address_pool" {
  type = map(object({
    loadbalancer_name = optional(string) # Support only LB which created in this module.
    loadbalancer_id   = optional(string)
  }))

  default = {}
}

variable "az_lb_nat_pool" {
  type = map(object({
    loadbalancer_name              = optional(string) # Support only LB which created in this module.
    loadbalancer_id                = optional(string)
    frontend_ip_configuration_name = string
    resource_group_name            = optional(string)

    backend_port      = number
    protocol          = string
    tcp_reset_enabled = optional(bool)

    frontend_port_start = number
    frontend_port_end   = number

    floating_ip_enabled = optional(bool)
  }))
  default = {}
}

variable "az_lb_nat_rule" {
  type = map(object({
    resource_group_name = optional(string)
    loadbalancer_name   = optional(string) # Support only LB which created in this module.
    loadbalancer_id     = optional(string)

    frontend_ip_configuration_name = string
    protocol                       = string
    frontend_port                  = number
    backend_port                   = number

    idle_timeout_in_minutes = optional(number)
    enable_floating_ip      = optional(string)
    enable_tcp_reset        = optional(bool)
  }))
}

variable "az_lb_rule" {
  type = map(object({
    loadbalancer_id                = optional(string)
    loadbalancer_name              = optional(string)
    protocol                       = string
    frontend_port                  = number
    backend_port                   = number
    frontend_ip_configuration_name = string

    backend_address_pool_ids   = optional(set(string))
    backend_address_pool_names = optional(set(string))

    probe_id   = optional(string)
    probe_name = optional(string)

    enable_floating_ip      = optional(bool)
    idle_timeout_in_minutes = optional(number)
    load_distribution       = optional(string) # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule#load_distribution
    disable_outbound_snat   = optional(bool)
    enable_tcp_reset        = optional(bool)
  }))

  default = {}
}

variable "az_lb_probe" {
  type = map(object({
    loadbalancer_id   = optional(string)
    loadbalancer_name = optional(string)
    protocol          = string
    port              = string

    request_path        = optional(string)
    interval_in_seconds = optional(string)
    number_of_probes    = optional(string)
  }))
  default = {}
}
