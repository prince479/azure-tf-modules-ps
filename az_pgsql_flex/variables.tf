variable "default_tags" {
  type    = map(string)
  default = {}
}
variable "postgres_flex_servers" {
  type = map(object({
    resource_group_name = string
    location            = string
    zone                = optional(string)

    delegated_subnet_id = optional(string)
    private_dns_zone_id = optional(string)

    administrator_login        = optional(string)
    administrator_password     = optional(string)
    administrator_gen_password = optional(bool)

    version     = optional(string)
    storage_mb  = optional(number)
    sku_name    = optional(string)
    create_mode = optional(string)

    backup_retention_days             = optional(number)
    point_in_time_restore_time_in_utc = optional(string)
    geo_redundant_backup_enabled      = optional(bool)

    high_availability = optional(object({
      mode                      = string
      standby_availability_zone = optional(number)
    }))

    maintenance_window = optional(object({
      day_of_week  = optional(number)
      start_hour   = optional(number)
      start_minute = optional(number)
    }))

    databases = optional(map(object({
      collation = optional(string)
      charset   = optional(string)
    })))

    firewall_rules = optional(map(object({
      start_ip_address = string
      end_ip_address   = string
    })))

    tags = map(string)
  }))
  default = {}
}

variable "psql_administrator_password" {
  type      = string
  sensitive = true
}
