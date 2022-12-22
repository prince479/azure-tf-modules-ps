variable "default_tags" {
  type    = map(string)
  default = {}
}
variable "az_redis" {
  type = map(object({
    location                      = string
    resource_group_name           = string
    capacity                      = number #The size of the Redis cache to deploy. Valid values for a SKU family of C (Basic/Standard) are 0, 1, 2, 3, 4, 5, 6, and for P (Premium) family are 1, 2, 3, 4.
    family                        = string # The SKU family/pricing group to use. Valid values are C (for Basic/Standard SKU family) and P (for Premium)
    sku_name                      = string #Possible values are Basic, Standard and Premium.
    enable_non_ssl_port           = optional(bool)
    minimum_tls_version           = optional(string)
    private_static_ip_address     = optional(string)
    public_network_access_enabled = optional(bool)
    replicas_per_master           = optional(number)
    replicas_per_primary          = optional(number)
    redis_version                 = optional(number)
    tenant_settings               = optional(map(string))
    shard_count                   = optional(number)
    subnet_id                     = optional(string)
    subnet_name                   = optional(string)
    tags                          = optional(map(string))
    zones                         = optional(set(string))

    redis_configuration = optional(object({
      aof_backup_enabled              = optional(bool)
      aof_storage_connection_string_0 = optional(string)
      aof_storage_connection_string_1 = optional(string)
      enable_authentication           = optional(bool)
      maxmemory_reserved              = optional(number)
      maxmemory_delta                 = optional(number)
      maxmemory_policy                = optional(number)
      maxfragmentationmemory_reserved = optional(number)
      rdb_backup_enabled              = optional(bool)
      rdb_backup_frequency            = optional(number)
      rdb_backup_max_snapshot_count   = optional(number)
      rdb_storage_connection_string   = optional(string)
      notify_keyspace_events          = optional(set(string))
    }))

    patch_schedule = optional(map(object({
      day_of_week        = string
      start_hour_utc     = optional(number)
      maintenance_window = optional(string)
    })))
  }))
}
