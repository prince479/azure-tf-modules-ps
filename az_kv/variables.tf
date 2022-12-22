variable "resource_group_name" {
  type        = string
  default     = null
  description = "Default Resource Group"
}

variable "location" {
  type        = string
  default     = null
  description = "Default Location"
}

variable "default_tags" {
  type        = map(string)
  description = "Default Tags"
  default     = {}
}

variable "key_vaults" {
  type = map(object({

    resource_group_name = optional(string)
    location            = optional(string)

    tenant_name = optional(string)

    soft_delete_retention_days = optional(number)
    purge_protection_enabled   = optional(bool)

    sku_name = string

    access_policy = optional(map(object({
      tenant_name = string
      object_name = string
    })))

    enabled_for_deployment          = optional(bool)
    enabled_for_disk_encryption     = optional(bool)
    enabled_for_template_deployment = optional(bool)
    enable_rbac_authorization       = optional(bool)

    access_policies = optional(map(object({
      object_id      = string
      application_id = optional(string)

      certificate_permissions = optional(set(string))
      key_permissions         = optional(set(string))
      secret_permissions      = optional(set(string))
      storage_permissions     = optional(set(string))
    })))

    role_assignments = optional(map(object({
      role_definition_id   = optional(string)
      role_definition_name = optional(string)

      managed_user_identity_name                = optional(string)
      managed_user_identity_resource_group_name = optional(string)

      condition         = optional(string)
      condition_version = optional(string)

      delegated_managed_identity_resource_id = optional(string)
      description                            = optional(string)
      skip_service_principal_aad_check       = optional(bool)
    })))

    contacts = optional(map(object({
      email = string
      phone = optional(string)
    })))

    tags = map(string)
  }))
}

variable "generated_keys" {
  type = map(object({
    key_vault_id = string
    key_type     = string
    key_size     = optional(number)
    curve        = optional(string)

    not_before_date = optional(string)

    # Notic: Expiration UTC datetime (Y-m-d'T'H:M:S'Z')
    expiration_date = optional(string)

    tags = map(string)

    key_opts = optional(set(string))
  }))

  default = {}
}
