locals {

  # fetch as list of obj of interface
  all_subnet_name_temp = flatten([
    for vm_key, vm_value in var.az_linux_vm_scale_set : {
      for i_vm_key, i_vm_value in vm_value.network_interfaces : "${i_vm_value.ip_configuration.subnet_name}-${vm_key}" => {
        vnet_name           = i_vm_value.ip_configuration.vnet_name
        subnet_name         = i_vm_value.ip_configuration.subnet_name
        resource_group_name = i_vm_value.ip_configuration.vnet_resource_group_name != null ? i_vm_value.ip_configuration.vnet_resource_group_name : var.resource_group_name
      }
    }
  ])

  # fetch as map object
  all_subnet_name = merge(local.all_subnet_name_temp...)
}

data "azurerm_subnet" "data_subnet" {
  for_each = local.all_subnet_name

  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.vnet_name
  name                 = each.value.subnet_name
}


resource "azurerm_linux_virtual_machine_scale_set" "main" {
  for_each = var.az_linux_vm_scale_set

  resource_group_name  = each.value.resource_group_name != null ? each.value.resource_group_name : var.resource_group_name
  location             = each.value.location != null ? each.value.location : var.location
  name                 = each.key
  instances            = each.value.instances
  sku                  = each.value.sku
  tags                 = merge(var.default_tags, each.value.tags)
  computer_name_prefix = each.value.computer_name_prefix

  admin_username = each.value.admin_username
  admin_password = each.value.admin_password

  priority        = each.value.priority
  eviction_policy = each.value.eviction_policy

  zones        = each.value.zones
  zone_balance = each.value.zone_balance
  vtpm_enabled = each.value.vtpm_enabled

  custom_data = (
    each.value.custom_data_fromfile == null && each.value.custom_data == null ? null :
    each.value.custom_data_fromfile != null && each.value.custom_data != null ?
    base64encode("${each.value.custom_data} \n ${file(each.value.custom_data_fromfile)}") :
    each.value.custom_data != null ?
    base64encode(each.value.custom_data) :
    filebase64(each.value.custom_data_fromfile)
  )

  user_data = (
    each.value.user_data_fromfile == null && each.value.user_data == null ? null :
    each.value.user_data_fromfile != null && each.value.user_data != null ?
    base64encode("${each.value.user_data} \n ${file(each.value.user_data_fromfile)}") :
    each.value.user_data != null ?
    base64encode(each.value.user_data) :
    filebase64(each.value.user_data_fromfile)
  )

  admin_ssh_key {
    username = each.value.admin_ssh_key.username
    public_key = (each.value.admin_ssh_key.public_key != null ? each.value.admin_ssh_key.public_key :
      each.value.admin_ssh_key.public_key_from_file != null ? file(each.value.admin_ssh_key.public_key_from_file) :
      var.public_key_from_env
    )
  }

  os_disk {
    caching                = each.value.os_disk.caching
    storage_account_type   = each.value.os_disk.storage_account_type
    disk_size_gb           = each.value.os_disk.disk_size_gb
    disk_encryption_set_id = each.value.os_disk.disk_encryption_set_id
  }

  dynamic "source_image_reference" {
    for_each = each.value.source_image_reference == null ? [] : [each.value.source_image_reference]

    content {
      publisher = source_image_reference.value.publisher
      offer     = source_image_reference.value.offer
      sku       = source_image_reference.value.sku
      version   = source_image_reference.value.version
    }
  }
  source_image_id = each.value.source_image_id

  #network_interface_ids = [for k, v in azurerm_network_interface.vm_interfaces : v.id if length(regexall("^${each.key}.*", v.name)) > 0]
  dynamic "network_interface" {
    for_each = each.value.network_interfaces #{ for k, v in local.all_network_interfaces_map : k => v if length(regexall("^${each.key}.*", k)) > 0 }
    #{ for k, v in azurerm_network_interface.vm_interfaces : k => v if length(regexall("^${each.key}.*", v.name)) > 0 }

    content {
      name                          = network_interface.key
      dns_servers                   = network_interface.value.dns_servers
      enable_accelerated_networking = network_interface.value.enable_accelerated_networking
      enable_ip_forwarding          = network_interface.value.enable_ip_forwarding
      network_security_group_id     = network_interface.value.network_security_group_id
      primary                       = network_interface.value.primary

      dynamic "ip_configuration" {
        for_each = network_interface.value.ip_configuration == null ? [] : [network_interface.value.ip_configuration]

        content {
          name                                         = "${each.key}-nic-${ip_configuration.value.name}" # lookup(ip_configuration.value, "name", null)
          primary                                      = lookup(ip_configuration.value, "primary", null)
          application_gateway_backend_address_pool_ids = lookup(ip_configuration.value, "application_gateway_backend_address_pool_ids", null)
          application_security_group_ids               = lookup(ip_configuration.value, "application_security_group_ids", null)
          load_balancer_backend_address_pool_ids       = lookup(ip_configuration.value, "load_balancer_backend_address_pool_ids", null)
          load_balancer_inbound_nat_rules_ids          = lookup(ip_configuration.value, "load_balancer_inbound_nat_rules_ids", null)

          subnet_id = (ip_configuration.value.subnet_id != null ? ip_configuration.value.subnet_id :
          [for k, v in data.azurerm_subnet.data_subnet : v.id if v.name == ip_configuration.value.subnet_name][0])

          version = lookup(ip_configuration.value, "version", null)

          dynamic "public_ip_address" {
            for_each = ip_configuration.value.public_ip_address == null ? [] : [ip_configuration.value.public_ip_address]
            content {
              name                    = public_ip_address.value.name
              domain_name_label       = public_ip_address.value.domain_name_label
              idle_timeout_in_minutes = public_ip_address.value.idle_timeout_in_minutes
              public_ip_prefix_id     = public_ip_address.value.public_ip_prefix_id
              dynamic "ip_tag" {
                for_each = public_ip_address.value.ip_tag == null ? {} : public_ip_address.value.ip_tag
                content {
                  tag  = ip_tag.key
                  type = ip_tag.value.type
                }
              }
            }
          }
        }
      }
    }
  }


}


# resource "azurerm_public_ip" "pip_prep" {
#   for_each = { for k, v in local.all_network_interfaces_map : k => v if v.enable_public_ip }

#   name                = "pip-${each.value.name}"
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   allocation_method   = [each.value.public_ip_allocation_method != null ? each.value.public_ip_allocation_method : "Dynamic"][0]

#   tags = each.value.tags
# }
