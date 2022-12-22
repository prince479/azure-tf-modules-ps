
locals {
  #all_network_interfaces = {}
  all_network_interfaces_map = merge([
    for vm_key, vm_value in var.az_vm_linux : {
      for i_vm_key, i_vm_value in vm_value.network_interfaces :
      "${vm_key}-nic-${i_vm_key}" => merge(i_vm_value, {
        vm_name             = vm_key
        name                = i_vm_value.name != null ? i_vm_value.name : "${vm_key}-nic-${i_vm_key}"
        resource_group_name = i_vm_value.resource_group_name != null ? i_vm_value.resource_group_name : var.resource_group_name
        location            = var.location
        enable_public_ip    = i_vm_value.enable_public_ip != null ? i_vm_value.enable_public_ip : false

        ip_configuration = merge(i_vm_value.ip_configuration, {
          subnet_id = (i_vm_value.ip_configuration.subnet_id != null ? i_vm_value.ip_configuration.subnet_id :
          [for k, v in data.azurerm_subnet.data_subnet : v.id if "snet-for-${i_vm_key}-${vm_key}" == k][0])
        })
        tags = vm_value.tags
      })
    }
  ]...)

  # fetch as list of obj of interface
  all_subnet_name = merge([
    for vm_key, vm_value in var.az_vm_linux : {
      for i_vm_key, i_vm_value in vm_value.network_interfaces :
      "snet-for-${i_vm_key}-${vm_key}" => {
        vnet_name   = i_vm_value.ip_configuration.vnet_name
        subnet_name = i_vm_value.ip_configuration.subnet_name
        resource_group_name = (i_vm_value.ip_configuration.vnet_resource_group_name != null ?
          i_vm_value.ip_configuration.vnet_resource_group_name : i_vm_value.resource_group_name != null ?
        i_vm_value.resource_group_name : var.resource_group_name)

      } if i_vm_value.ip_configuration.vnet_name != null && i_vm_value.ip_configuration.subnet_name != null ? true : false
    }
  ]...)

}
data "azurerm_subnet" "data_subnet" {
  for_each = local.all_subnet_name

  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.vnet_name
  name                 = each.value.subnet_name
}

resource "azurerm_linux_virtual_machine" "vm_linux" {
  for_each = var.az_vm_linux

  resource_group_name = var.resource_group_name
  location            = var.location
  name                = each.key

  computer_name  = each.value.computer_name
  size           = each.value.size
  admin_username = each.value.admin_username
  admin_password = each.value.admin_password != null ? each.value.admin_password : var.linux_admin_password
  disable_password_authentication = each.value.disable_password_authentication

  priority        = each.value.priority
  eviction_policy = each.value.eviction_policy

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

 /* admin_ssh_key {
    username = each.value.admin_ssh_key.username
    public_key = (each.value.admin_ssh_key.public_key != null ? each.value.admin_ssh_key.public_key :
      each.value.admin_ssh_key.public_key_from_file != null ? file(each.value.admin_ssh_key.public_key_from_file) :
      var.public_key_from_env
    )
  }*/

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

  network_interface_ids = [for k, v in azurerm_network_interface.vm_interfaces : v.id if length(regexall("^${each.key}.*", k)) > 0]

  tags = merge(var.default_tags, each.value.tags)
}

resource "azurerm_network_interface" "vm_interfaces" {
  for_each = local.all_network_interfaces_map

  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  name                          = each.value.name
  enable_accelerated_networking = each.value.enable_accelerated_networking

  ip_configuration {
    name                          = each.value.ip_configuration.name
    subnet_id                     = each.value.ip_configuration.subnet_id
    private_ip_address_allocation = each.value.ip_configuration.private_ip_address_allocation
    private_ip_address            = each.value.ip_configuration.private_ip_address
    public_ip_address_id          = try(element([for k, v in azurerm_public_ip.pip_prep : v.id if length(regexall("^pip-${each.value.name}", v.name)) > 0], 0), null)
  }

  tags = merge(var.default_tags, each.value.tags)
}

resource "azurerm_public_ip" "pip_prep" {
  for_each = { for k, v in local.all_network_interfaces_map : k => v if v.enable_public_ip }

  name                = "pip-${each.value.name}"
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  allocation_method   = [each.value.public_ip_allocation_method != null ? each.value.public_ip_allocation_method : "Dynamic"][0]

  tags = merge(var.default_tags, each.value.tags)
}
/*
data "azurerm_backup_policy_vm" "policy" {
  name                = var.backup_policy_name
  recovery_vault_name = var.recovery_vault_name
  resource_group_name = var.backup_resource_group_name
}
resource "azurerm_backup_protected_vm" "recovery_vault_backup_enable" {
  for_each = var.az_vm_linux
  resource_group_name = var.backup_resource_group_name
  recovery_vault_name = var.recovery_vault_name
  source_vm_id        = azurerm_linux_virtual_machine.vm_linux[each.key].id
  backup_policy_id    = data.azurerm_backup_policy_vm.policy.id
}*/
