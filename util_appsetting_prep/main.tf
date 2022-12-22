locals {
  app_services_prep = {
    for k_aws, v_aws in var.app_services :
    k_aws => merge(v_aws, {
      sticky_settings = {
        app_setting_names = (length(setunion(try(var.default_sticky_settings.app_setting_names == null ? [] : var.default_sticky_settings.app_setting_names, []), try(v_aws.sticky_settings.app_setting_names == null ? [] : v_aws.sticky_settings.app_setting_names, []))) == 0 ? null :
        setunion(try(var.default_sticky_settings.app_setting_names == null ? [] : var.default_sticky_settings.app_setting_names, []), try(v_aws.sticky_settings.app_setting_names == null ? [] : v_aws.sticky_settings.app_setting_names, [])))

        connection_string_names = (length(setunion(try(var.default_sticky_settings.connection_string_names == null ? [] : var.default_sticky_settings.connection_string_names, []), try(v_aws.sticky_settings.connection_string_names == null ? [] : v_aws.sticky_settings.connection_string_names, []))) == 0 ? null :
        setunion(try(var.default_sticky_settings.connection_string_names == null ? [] : var.default_sticky_settings.connection_string_names, []), try(v_aws.sticky_settings.connection_string_names == null ? [] : v_aws.sticky_settings.connection_string_names, [])))
      }
      app_settings = merge(try(var.default_app_settings == null ? {} : var.default_app_settings, {}), try(v_aws.app_settings == null ? {} : v_aws.app_settings, {}))
    })
  }


  # Remove sticky_settings if all attribute is null.
  app_services_checked = {
    for k_aws, v_aws in local.app_services_prep :
    k_aws => v_aws.sticky_settings.app_setting_names == null && v_aws.sticky_settings.connection_string_names == null ? merge(v_aws, { sticky_settings = null }) : v_aws
  }
}
