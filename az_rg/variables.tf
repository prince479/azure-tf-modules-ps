variable "location" {
  type        = string
  description = "Default location for all resource group"
  default     = null
}
variable "default_tags" {
  type        = map(string)
  description = "Default tags for all resource group"
  default     = {}
}
variable "resource_groups" {
  type = map(object({
    location = optional(string)
    tags     = optional(map(string))
  }))
  default     = {}
  description = "Map Resource group you can override location and tag in maping"
}
