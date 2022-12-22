variable "app_services" {}

variable "default_app_settings" {
  type    = map(string)
  default = {}
}
variable "default_sticky_settings" {
  type = object({
    app_setting_names       = optional(set(string))
    connection_string_names = optional(set(string))
  })
  default = {}
}
