
locals {
  declared_default_field = contains(keys(var.manifest), "default")
}

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

  precondition {
    condition = !(
      local.declared_default_field && try(var.manifest.default, null) == null
    )
    error_message = <<-EOT
    Invalid Manifest!
    The default value a bool field can't be null;
    The filed ${var.field_path} has it's default value set to null.
    (metadata: ${var.metadata_name}; path: ${var.path}; )
EOT
  }
}
