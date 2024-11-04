locals {
  minimum = var.schema.validations.minimum != null ? var.schema.validations.minimum : 0
  maximum = var.schema.validations.maximum != null ? var.schema.validations.maximum : 0
  value   = var.manifest != null ? try(tonumber(var.manifest), 0) : 0
}
output "resource" {
  value = try(tonumber(var.manifest), null)

  precondition {
    condition     = var.manifest != null
    error_message = <<-EOT
      Invalid resource manifest!
      The property "${var.field_path}" can not be null.
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }

  precondition {
    condition     = can(tonumber(var.manifest))
    error_message = <<-EOT
      Invalid resource manifest!
      The type of the property "${var.field_path}" must be integer.
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }

  precondition {
    condition     = try(var.manifest >= var.schema.validations.minimum, true)
    error_message = <<-EOT
      Invalid resource manifest!
      The minimum length of the property "${var.field_path}" must be ${local.minimum} (got: ${local.value}).
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }

  precondition {
    condition     = try(var.manifest <= var.schema.validations.maximum, true)
    error_message = <<-EOT
      Invalid resource manifest!
      The minimum length of the property "${var.field_path}" must be ${local.maximum} (got: ${local.value}).
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }
}
