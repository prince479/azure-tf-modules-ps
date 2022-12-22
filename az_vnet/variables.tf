variable "az_vnets" {
  type = map(object({
    address_spaces      = set(string)
    resource_group_name = optional(string)
    location            = optional(string)
    tags                = optional(map(string))
  }))
}

variable "default_tags" {
  type        = map(string)
  description = "Default Tags"
  default     = {}
}

variable "resource_group_name" {
  type        = string
  description = "Default Resource Group"
  default     = null
}

variable "location" {
  type        = string
  description = "Default Location"
  default     = null
}
