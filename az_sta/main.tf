locals {
  all_container = merge([
    for k_sta, v_sta in var.storage_accounts : {
      for k_container, v_container in v_sta.storage_containers : "${k_container}-${k_sta}" => merge(v_container,
        {
          name                 = k_container,
          storage_account_name = k_sta
      })
    } if v_sta.storage_containers != null
  ]...)

  all_fileshare = merge([
    for k_sta, v_sta in var.storage_accounts : {
      for k_fileshare, v_fileshare in v_sta.storage_fileshares : "${k_fileshare}-${k_sta}" => merge(v_fileshare,
        {
          name                 = k_fileshare,
          storage_account_name = k_sta
      })
    } if v_sta.storage_fileshares != null
  ]...)
}


resource "azurerm_storage_account" "main" {
  for_each = var.storage_accounts

  resource_group_name = each.value.resource_group_name == null ? var.resource_group : each.value.resource_group_name
  location            = each.value.location == null ? var.location : each.value.location
  name                = each.key

  account_tier             = each.value.account_tier
  access_tier              = each.value.access_tier
  account_replication_type = each.value.account_replication_type
  account_kind             = each.value.account_kind

  enable_https_traffic_only = each.value.enable_https_traffic_only
  min_tls_version           = each.value.min_tls_version

  shared_access_key_enabled = each.value.shared_access_key_enabled

  allow_nested_items_to_be_public  = each.value.allow_nested_items_to_be_public
  cross_tenant_replication_enabled = each.value.cross_tenant_replication_enabled
  edge_zone                        = each.value.edge_zone

  infrastructure_encryption_enabled = each.value.infrastructure_encryption_enabled
  is_hns_enabled                    = each.value.is_hns_enabled
  large_file_share_enabled          = each.value.large_file_share_enabled
  nfsv3_enabled                     = each.value.nfsv3_enabled
  dynamic "blob_properties" {
    for_each = each.value.blob_properties == null ? [] : [each.value.blob_properties]

    content {
      change_feed_enabled      = blob_properties.value.change_feed_enabled
      default_service_version  = blob_properties.value.default_service_version
      last_access_time_enabled = blob_properties.value.last_access_time_enabled
      versioning_enabled       = blob_properties.value.versioning_enabled

      dynamic "container_delete_retention_policy" {
        for_each = blob_properties.value.container_delete_retention_policy == null ? [] : [blob_properties.value.container_delete_retention_policy]

        content {
          days = container_delete_retention_policy.value.days
        }
      }
      dynamic "cors_rule" {
        for_each = blob_properties.value.cors_rule == null ? [] : [blob_properties.value.cors_rule]
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }
      dynamic "delete_retention_policy" {
        for_each = blob_properties.value.delete_retention_policy == null ? [] : [blob_properties.value.delete_retention_policy]
        content {
          days = delete_retention_policy.value.days
        }
      }
    }
  }

  dynamic "identity" {
    for_each = each.value.identity == null ? [] : [each.value.identity]
    content {
      identity_ids = identity.value.identity_ids
      type         = identity.value.type
    }
  }

  dynamic "azure_files_authentication" {
    for_each = each.value.azure_files_authentication == null ? [] : [each.value.azure_files_authentication]
    content {
      directory_type = azure_files_authentication.value.directory_type
      dynamic "active_directory" {
        for_each = azure_files_authentication.value.active_directory == null ? [] : [azure_files_authentication.value.active_directory]
        content {
          storage_sid         = active_directory.value.storage_sid
          netbios_domain_name = active_directory.value.netbios_domain_name
          domain_guid         = active_directory.value.domain_guid
          domain_name         = active_directory.value.domain_name
          domain_sid          = active_directory.value.domain_sid
          forest_name         = active_directory.value.forest_name
        }
      }
    }
  }

  dynamic "custom_domain" {
    for_each = each.value.custom_domain == null ? [] : [each.value.custom_domain]
    content {
      name          = custom_domain.value.name
      use_subdomain = custom_domain.value.use_subdomain
    }
  }

  dynamic "customer_managed_key" {
    for_each = each.value.customer_managed_key == null ? [] : [each.value.customer_managed_key]
    content {
      key_vault_key_id          = customer_managed_key.value.key_vault_key_id
      user_assigned_identity_id = customer_managed_key.value.user_assigned_identity_id
    }
  }

  dynamic "network_rules" {
    for_each = each.value.network_rules == null ? {} : each.value.network_rules
    content {
      default_action = network_rules.value.default_action
      bypass         = network_rules.value.bypass
      ip_rules       = network_rules.value.ip_rules

      virtual_network_subnet_ids = network_rules.value.virtual_network_subnet_ids

      dynamic "private_link_access" {
        for_each = network_rules.value.private_link_access == null ? {} : network_rules.value.private_link_access
        content {
          endpoint_resource_id = private_link_access.value.endpoint_resource_id
          endpoint_tenant_id   = private_link_access.value.endpoint_tenant_id
        }
      }
    }
  }

  tags = each.value.tags
}

resource "azurerm_storage_container" "containers" {
  for_each = local.all_container == null ? {} : local.all_container

  name                  = each.value.name
  storage_account_name  = each.value.storage_account_name
  container_access_type = each.value.container_access_type
  metadata              = each.value.metadata

  depends_on = [
    azurerm_storage_account.main
  ]
}

resource "azurerm_storage_share" "fileshares" {
  for_each = local.all_fileshare == null ? {} : local.all_fileshare

  name                 = each.value.name
  storage_account_name = each.value.storage_account_name
  quota                = each.value.quota
  access_tier          = each.value.access_tier
}
