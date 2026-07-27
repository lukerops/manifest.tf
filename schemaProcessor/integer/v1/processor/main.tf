locals {
  declared_default_field       = contains(keys(var.manifest), "default")
  has_compatible_default_value = can(tonumber(try(var.manifest.default, null)))
}

output "schema" {
  value = {
    type    = "integer"
    version = "v1"
    subItem = null
    validations = {
      minimum           = try(tonumber(var.manifest.minimum), null)
      maximum           = try(tonumber(var.manifest.maximum), null)
      has_default_value = can(var.manifest.default) ? true : false
      default_value     = try(tonumber(var.manifest.default), null)
    }
  }

  precondition {
    condition     = can(tonumber(try(var.manifest.minimum, null)))
    error_message = <<-EOT
      Invalid "minimum" value.
      The field "${var.field_path}.minimum" must be a number.
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = can(tonumber(try(var.manifest.maximum, null)))
    error_message = <<-EOT
      Invalid "maximum" value.
      The field "${var.field_path}.maximum" must be a number.
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = try(var.manifest.minimum < var.manifest.maximum, true)
    error_message = <<-EOT
      Invalid "minimum" and "maximum" values.
      The field "${var.field_path}.minimum" must be less than "${var.field_path}.maximum".
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition = !(local.declared_default_field && try(var.manifest.default, null) == null)
    error_message = <<-EOT
      Invalid Manifest!
      The default value of an integer field can't be null.
      The field "${var.field_path}" has its default value set to null.
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }

  precondition {
    condition     = local.has_compatible_default_value
    error_message = <<-EOT
      Invalid resource manifest!
      The default value of the property "${var.field_path}" must be compatible with type integer.
      Current default value: ${format("%v", try(var.manifest.default, "null"))}
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }
}
