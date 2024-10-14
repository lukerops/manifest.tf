output "schema" {
  value = {
    type    = "bool"
    version = "v1"
    subItem = null
    validations = {
      has_default_value = can(var.manifest.default) ? true : false
      default_value     = try(var.manifest.default, null)
    }
  }
}
