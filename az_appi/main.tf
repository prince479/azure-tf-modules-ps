# Application Inside

locals {
  all_workspace_map = try(merge(flatten([
    for k_appi, v_appi in var.app_insights : {
      for k_log, v_log in v_appi.log_analytics_workspace :
      "${k_log}-${k_appi}" => {
        name                = k_log
        sku                 = v_log.sku
        retention_in_days   = v_log.retention_in_days
        daily_quota_gb      = v_log.daily_quota_gb  
        cmk_for_query_forced = v_log.cmk_for_query_forced
        resource_group_name = v_appi.resource_group_name != null ? v_appi.resource_group_name : var.resource_group_name
        location            = v_appi.location != null ? v_appi.location : var.location
        tags                = v_appi.tags
      }
    }
  ])...), {})

}

resource "azurerm_application_insights" "main" {
  for_each = var.app_insights

  resource_group_name = each.value.resource_group_name != null ? each.value.resource_group_name : var.resource_group_name
  location            = each.value.location != null ? each.value.location : var.location
  name                = each.key

  application_type = each.value.application_type
  workspace_id     = each.value.workspace_id != null ? each.value.workspace_id : [for k, v in azurerm_log_analytics_workspace.main : v.id if "${keys(each.value.log_analytics_workspace)[0]}-${each.key}" == k][0]

  daily_data_cap_in_gb                  = each.value.daily_data_cap_in_gb
  daily_data_cap_notifications_disabled = each.value.daily_data_cap_notifications_disabled
  retention_in_days                     = each.value.retention_in_days
  sampling_percentage                   = each.value.sampling_percentage
  disable_ip_masking                    = each.value.disable_ip_masking
  local_authentication_disabled         = each.value.local_authentication_disabled
  internet_ingestion_enabled            = each.value.internet_ingestion_enabled
  internet_query_enabled                = each.value.internet_query_enabled
  force_customer_storage_for_profiler   = each.value.force_customer_storage_for_profiler

  tags = each.value.tags
}

resource "azurerm_log_analytics_workspace" "main" {
  for_each = local.all_workspace_map

  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  name                = each.value.name

  sku               = each.value.sku
  retention_in_days = each.value.retention_in_days
  daily_quota_gb    = each.value.daily_quota_gb 
  cmk_for_query_forced = each.value.cmk_for_query_forced

  tags = merge(var.default_tags, each.value.tags)
}
