

resource "azurerm_redis_cache" "main" {
  for_each = var.az_redis

  name                = each.key
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  capacity            = each.value.capacity
  family              = each.value.family
  sku_name            = each.value.sku_name
  enable_non_ssl_port = each.value.enable_non_ssl_port
  minimum_tls_version = each.value.minimum_tls_version

  private_static_ip_address     = each.value.private_static_ip_address
  public_network_access_enabled = each.value.public_network_access_enabled

  replicas_per_master  = each.value.replicas_per_master
  replicas_per_primary = each.value.replicas_per_primary
  redis_version        = each.value.redis_version

  tenant_settings = each.value.tenant_settings
  shard_count     = each.value.shard_count
  subnet_id       = each.value.subnet_id
  tags            = merge(each.value.tags, var.default_tags)
  zones           = each.value.zones

  dynamic "redis_configuration" {
    for_each = each.value.redis_configuration == null ? [] : [each.value.redis_configuration]

    content {
      aof_backup_enabled              = redis_configuration.value.aof_backup_enabled
      aof_storage_connection_string_0 = redis_configuration.value.aof_storage_connection_string_0
      aof_storage_connection_string_1 = redis_configuration.value.aof_storage_connection_string_1
      enable_authentication           = redis_configuration.value.enable_authentication
      maxmemory_reserved              = redis_configuration.value.maxmemory_reserved
      maxmemory_delta                 = redis_configuration.value.maxmemory_delta
      maxmemory_policy                = redis_configuration.value.maxmemory_policy
      maxfragmentationmemory_reserved = redis_configuration.value.maxfragmentationmemory_reserved
      rdb_backup_enabled              = redis_configuration.value.rdb_backup_enabled
      rdb_backup_frequency            = redis_configuration.value.rdb_backup_frequency
      rdb_backup_max_snapshot_count   = redis_configuration.value.rdb_backup_max_snapshot_count
      rdb_storage_connection_string   = redis_configuration.value.rdb_storage_connection_string
      notify_keyspace_events          = redis_configuration.value.notify_keyspace_events
    }
  }

  dynamic "patch_schedule" {
    for_each = each.value.patch_schedule == null ? {} : each.value.patch_schedule
    content {
      day_of_week        = patch_schedule.value.day_of_week
      start_hour_utc     = patch_schedule.value.start_hour_utc
      maintenance_window = patch_schedule.value.maintenance_window
    }
  }
}
