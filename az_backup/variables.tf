variable "backup_vault" {
  type = map(object({
    location                 = string
    resource_group_name      = string
    sku                      = optional(string)
    soft_delete_enabled      = optional(bool)
    storage_mode_type        = optional(string)
    backup_policy_name  = string
    timezone            = string
    backup_frequency    = string
    retention_daily     = number
    time                = string
  }))
  default = {}
}


variable "default_tags" {
  type    = map(string)
  default = {}
}
