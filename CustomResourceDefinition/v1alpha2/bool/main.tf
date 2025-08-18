
locals {
  declared_default_field       = contains(keys(var.manifest), "default")
  has_compatible_default_value = can(tobool(try(var.manifest.default, null)))
}

output "schema" {
  value = {
    type    = "bool"
    version = "v1"
    subItem = null
    validations = {
      has_default_value = can(var.manifest.default) ? true : false
      default_value     = try(tobool(var.manifest.default), null)
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

  precondition {
    condition     = local.has_compatible_default_value
    error_message = <<-EOT
      Invalid resource manifest!
      The default value of the property "${var.field_path}" must be compatible with type bool.
      Current default value: ${format("%v", try(var.manifest.default, "null"))}
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }
}
