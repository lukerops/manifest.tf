locals {
  declared_default_field        = contains(keys(var.manifest), "default")
  has_compatible_default_value  = can(tostring(try(var.manifest.default, null)))
}

output "schema" {
  value = {
    type    = "string"
    version = "v1"
    subItem = null
    validations = {
      minLength         = try(tonumber(var.manifest.minLength), null)
      maxLength         = try(tonumber(var.manifest.maxLength), null)
      has_default_value = can(var.manifest.default) ? true : false
      default_value     = try(tostring(var.manifest.default), null)
    }
  }

  precondition {
    condition     = can(tonumber(try(var.manifest.minLength, null)))
    error_message = <<-EOT
      Invalid "minLength" value.
      The field "${var.field_path}.minLength" must be a number.
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = try(tonumber(var.manifest.minLength) >= 0, true)
    error_message = <<-EOT
      Invalid "minLength" value.
      The field "${var.field_path}.minLength" must be greater than or equal to 0.
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = can(tonumber(try(var.manifest.maxLength, null)))
    error_message = <<-EOT
      Invalid "maxLength" value.
      The field "${var.field_path}.maxLength" must be a number.
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = try(tonumber(var.manifest.maxLength) >= 1, true)
    error_message = <<-EOT
      Invalid "maxLength" value.
      The field "${var.field_path}.maxLength" must be greater than or equal to 1.
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = try(var.manifest.minLength < var.manifest.maxLength, true)
    error_message = <<-EOT
      Invalid "minLength" and "maxLength" values.
      The field "${var.field_path}.minLength" must be less than "${var.field_path}.maxLength".
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition = !(local.declared_default_field && try(var.manifest.default, null) == null)
    error_message = <<-EOT
      Invalid Manifest!
      The default value of a string field can't be null.
      The field "${var.field_path}" has its default value set to null.
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }

  precondition {
    condition     = local.has_compatible_default_value
    error_message = <<-EOT
      Invalid resource manifest!
      The default value of the property "${var.field_path}" must be compatible with type string.
      Current default value: ${format("%v", try(var.manifest.default, "null"))}
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }
}
