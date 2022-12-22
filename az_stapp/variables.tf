variable "resource_group_name" {
  type        = string
  description = "Default Resource Group"
  default     = null
}

variable "location" {
  type        = string
  description = "Default Resource Group"
  default     = null
}

variable "default_tags" {
  type    = map(string)
  default = {}
}

variable "az_static_web_apps" {
  type = map(object({
    resource_group_name = optional(string)
    location            = optional(string)
    sku_tier            = optional(string)
    sku_size            = optional(string)
    tags                = optional(string)
    identity = optional(object({
      type         = string
      identity_ids = set(string)
    }))
  }))
  default = {}
}
