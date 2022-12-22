
variable "location" {
  type        = string
  description = "Default location for all resource group"
  default     = null
}

variable "resource_group_name" {
  type        = string
  default     = null
  description = "Default ressource group name"
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags for all resource group"
  default     = {}
}

variable "az_user_assigned_ids" {
  type = map(object({
    resource_group_name = optional(string)
    location            = optional(string)
    tags                = map(string)
  }))
}
