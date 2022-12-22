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

variable "app_insights" {
  type = map(object({
    resource_group_name = optional(string)
    location            = optional(string)

    #Specifies the type of Application Insights to create. Valid values are 
    #ios for iOS, 
    #java for Java web, 
    #MobileCenter for App Center, 
    #Node.JS for Node.js, 
    #other for General, 
    #phone for Windows Phone, 
    #store for Windows Store and 
    #web for ASP.NET. 
    #Please note these values are case sensitive; unmatched values are treated as ASP.NET by Azure. Changing this forces a new resource to be created.
    application_type = string

    daily_data_cap_in_gb = optional(number)

    #Specifies if a notification email will be send when the daily data volume cap is met.
    daily_data_cap_notifications_disabled = optional(string)

    retention_in_days                   = optional(number)
    sampling_percentage                 = optional(number)
    disable_ip_masking                  = optional(bool)
    local_authentication_disabled       = optional(bool)
    internet_ingestion_enabled          = optional(bool)
    internet_query_enabled              = optional(bool)
    force_customer_storage_for_profiler = optional(bool)

    # if you specify this, 'log_analytics_workspace' will be ignored
    workspace_id = optional(string)

    # Specify this if you want to create log workspace.
    log_analytics_workspace = optional(map(object({
      # Name is the key

      #Log Analytics Workspace. Possible values are 
      #Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018 (new SKU as of 2018-04-03). Defaults to PerGB2018.
      sku               = optional(string)
      daily_quota_gb = number
      cmk_for_query_forced = optional(string)
      retention_in_days = number
    })))

    tags = map(string)
  }))
}
