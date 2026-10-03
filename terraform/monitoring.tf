resource "azurerm_log_analytics_workspace" "main" {
  name                = "azure-production-log"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  sku               = "PerGB2018"
  retention_in_days = 30
}

resource "azurerm_application_insights" "main" {
  name                = "azure-production-appinsights"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  application_type = "web"
  workspace_id     = azurerm_log_analytics_workspace.main.id
}

resource "azurerm_monitor_diagnostic_setting" "function" {
  name                       = "function-diagnostics"
  target_resource_id         = azurerm_function_app_flex_consumption.app.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "FunctionAppLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "function_5xx" {
  name                = "function-http-5xx-alert"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  scopes               = [azurerm_application_insights.main.id]
  severity             = 2

  criteria {
    query = <<-QUERY
      requests
      | where toint(resultCode) >= 500
      | summarize ErrorCount = count()
    QUERY

    time_aggregation_method = "Total"
    metric_measure_column   = "ErrorCount"
    operator                = "GreaterThan"
    threshold               = 0

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  description = "Alert when the Function App records HTTP 5xx requests."
  enabled     = true
}