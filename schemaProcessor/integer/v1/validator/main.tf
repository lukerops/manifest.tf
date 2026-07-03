locals {
  has_default_value  = var.schema.validations.has_default_value
  value              = var.manifest != null ? try(tonumber(var.manifest), null) : var.schema.validations.default_value
  minimum            = var.schema.validations.minimum != null ? var.schema.validations.minimum : 0
  maximum            = var.schema.validations.maximum != null ? var.schema.validations.maximum : 0
  value_for_display  = local.value != null ? local.value : "null"
}

output "resource" {
  value = local.value

  precondition {
    condition = !(
      !local.has_default_value
      && var.manifest == null
    )
    error_message = <<-EOT
      Invalid resource manifest!
      The property "${var.field_path}" can not be null and have no default value.
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
      The value of the property "${var.field_path}" must be greater than or equal to ${local.minimum} (got: ${local.value_for_display}).
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }

  precondition {
    condition     = try(var.manifest <= var.schema.validations.maximum, true)
    error_message = <<-EOT
      Invalid resource manifest!
      The value of the property "${var.field_path}" must be less than or equal to ${local.maximum} (got: ${local.value_for_display}).
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }
}
