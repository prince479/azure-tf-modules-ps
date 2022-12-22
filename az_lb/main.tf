locals {
  all_subnet = flatten([
    for k_lb, v_lb in var.az_lb : {
      for k_front, v_front in v_lb.frontend_ip_configuration :
      "fipconf-${k_front}-${k_lb}" => {
        subnet_name = v_front.subnet_name
        vnet_name   = v_front.vnet_name
        resource_group_name = (v_front.vnet_resource_group_name != null ?
          v_front.vnet_resource_group_name : v_lb.resource_group_name != null ?
        v_lb.resource_group_name : var.resource_group_name)
      } if v_front.subnet_name != null
    } if v_lb.frontend_ip_configuration != null
  ])
  all_subnet_map = merge(local.all_subnet...)

}

data "azurerm_subnet" "subnet_for_frontend_ip" {
  for_each = local.all_subnet_map

  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.resource_group_name
}

resource "azurerm_lb" "main" {
  for_each = var.az_lb

  name                = each.key
  location            = each.value.location != null ? each.value.location : var.location
  resource_group_name = each.value.resource_group_name != null ? each.value.resource_group_name : var.resource_group_name
  edge_zone           = each.value.edge_zone

  # Basic, Standard and Gateway. Defaults to Basic.
  sku = each.value.sku
  # Global and Regional. Defaults to Regional
  sku_tier = each.value.sku_tier

  dynamic "frontend_ip_configuration" {
    for_each = each.value.frontend_ip_configuration == null ? {} : each.value.frontend_ip_configuration

    content {
      name = frontend_ip_configuration.key
      # availability_zone                                  = frontend_ip_configuration.value.availability_zone
      subnet_id = (frontend_ip_configuration.value.subnet_id != null ? frontend_ip_configuration.value.subnet_id :
        [for k, v in data.azurerm_subnet.subnet_for_frontend_ip :
        v.id if v.name == frontend_ip_configuration.value.subnet_name && v.virtual_network_name == frontend_ip_configuration.value.vnet_name][0]
      )
      gateway_load_balancer_frontend_ip_configuration_id = frontend_ip_configuration.value.gateway_load_balancer_frontend_ip_configuration_id
      private_ip_address                                 = frontend_ip_configuration.value.private_ip_address

      #Dynamic and Static
      private_ip_address_allocation = frontend_ip_configuration.value.private_ip_address_allocation
      # IPv4 or IPv6
      private_ip_address_version = frontend_ip_configuration.value.private_ip_address_version
      public_ip_address_id       = frontend_ip_configuration.value.public_ip_address_id
      public_ip_prefix_id        = frontend_ip_configuration.value.public_ip_prefix_id
    }
  }

  tags = merge(var.default_tags, each.value.tags)
}

resource "azurerm_lb_backend_address_pool" "main" {
  for_each = var.az_lb_backend_address_pool

  loadbalancer_id = each.value.loadbalancer_id != null ? each.value.loadbalancer_id : lookup(azurerm_lb.main, each.value.loadbalancer_name).id
  name            = each.key
}


resource "azurerm_lb_probe" "main" {
  for_each = var.az_lb_probe

  loadbalancer_id = each.value.loadbalancer_id != null ? each.value.loadbalancer_id : lookup(azurerm_lb.main, each.value.loadbalancer_name).id
  name            = each.key
  protocol        = each.value.protocol
  port            = each.value.port

  request_path        = each.value.request_path
  interval_in_seconds = each.value.interval_in_seconds
  number_of_probes    = each.value.number_of_probes
}

resource "azurerm_lb_nat_pool" "main" {
  for_each = var.az_lb_nat_pool

  resource_group_name = each.value.resource_group_name != null ? each.value.resource_group_name : var.resource_group_name
  name                = each.key
  loadbalancer_id     = each.value.loadbalancer_id != null ? each.value.loadbalancer_id : lookup(azurerm_lb.main, each.value.loadbalancer_name).id

  backend_port      = each.value.backend_port
  protocol          = each.value.protocol
  tcp_reset_enabled = each.value.tcp_reset_enabled

  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  frontend_port_start            = each.value.frontend_port_start
  frontend_port_end              = each.value.frontend_port_end

  floating_ip_enabled = each.value.floating_ip_enabled
}

resource "azurerm_lb_nat_rule" "main" {
  for_each = var.az_lb_nat_rule

  resource_group_name = each.value.resource_group_name != null ? each.value.resource_group_name : var.resource_group_name
  name                = each.key
  loadbalancer_id     = each.value.loadbalancer_id != null ? each.value.loadbalancer_id : lookup(azurerm_lb.main, each.value.loadbalancer_name).id

  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port

  idle_timeout_in_minutes = each.value.idle_timeout_in_minutes
  enable_floating_ip      = each.value.enable_floating_ip
  enable_tcp_reset        = each.value.enable_tcp_reset
}

resource "azurerm_lb_rule" "example" {
  for_each = var.az_lb_rule

  loadbalancer_id                = each.value.loadbalancer_id != null ? each.value.loadbalancer_id : lookup(azurerm_lb.main, each.value.loadbalancer_name).id
  name                           = each.key
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name

  backend_address_pool_ids = each.value.backend_address_pool_ids != null ? each.value.backend_address_pool_ids : [for k, v in azurerm_lb_backend_address_pool.main : v.id if contains(each.value.backend_address_pool_names, k)]


  probe_id = each.value.probe_id != null ? each.value.probe_id : try(lookup(azurerm_lb_probe.main, each.value.probe_name).id, null)

  enable_floating_ip      = each.value.enable_floating_ip
  idle_timeout_in_minutes = each.value.idle_timeout_in_minutes
  load_distribution       = each.value.load_distribution
  disable_outbound_snat   = each.value.disable_outbound_snat
  enable_tcp_reset        = each.value.enable_tcp_reset

  depends_on = [
    azurerm_lb.main,
    azurerm_lb_backend_address_pool.main,
    azurerm_lb_probe.main
  ]
}
