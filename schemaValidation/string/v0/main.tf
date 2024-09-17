locals {
  minLength      = var.schema.validations.minLength != null ? var.schema.validations.minLength : 0
  maxLength      = var.schema.validations.maxLength != null ? var.schema.validations.maxLength : 0
  manifestLength = try(length(var.manifest), 0)
}
output "resource" {
  value = try(tostring(var.manifest), null)

  precondition {
    condition     = var.manifest != null
    error_message = <<-EOT
      Invalid resource manifest!
      The property "${var.field_path}" can not be null.
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }

  precondition {
    condition     = can(tostring(var.manifest))
    error_message = <<-EOT
      Invalid resource manifest!
      The type of the property "${var.field_path}" must be string.
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }

  precondition {
    condition     = try(length(var.manifest) >= var.schema.validations.minLength, true)
    error_message = <<-EOT
      Invalid resource manifest!
      The minimum length of the property "${var.field_path}" must be ${local.minLength} (got: ${local.manifestLength}).
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }

  precondition {
    condition     = try(length(var.manifest) <= var.schema.validations.maxLength, true)
    error_message = <<-EOT
      Invalid resource manifest!
      The minimum length of the property "${var.field_path}" must be ${local.maxLength} (got: ${local.manifestLength}).
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }
}
