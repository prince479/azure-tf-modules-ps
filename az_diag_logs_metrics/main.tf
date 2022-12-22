resource "azurerm_monitor_diagnostic_setting" "diag" {
  for_each = var.target_resource
  name                       = "diag-${each.key}"
  target_resource_id         = each.value
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "log" {
    for_each = var.logs
    content {
      category = log.value
      enabled  = true
 
      retention_policy {
        enabled = true
        days    = 30
      }
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = 30
    }
  }
}
