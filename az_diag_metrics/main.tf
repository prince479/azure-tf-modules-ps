resource "azurerm_monitor_diagnostic_setting" "metrics" {
  for_each = var.target_resource
  name                       = "diag-${each.key}"
  target_resource_id         = each.value
  log_analytics_workspace_id = var.log_analytics_workspace_id

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = 30
    }
  }
}
