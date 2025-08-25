locals {
  has_default_value = var.schema.validations.has_default_value
}

output "resource" {
  value = var.manifest != null ? tobool(var.manifest) : var.schema.validations.default_value

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
    condition     = can(tobool(var.manifest))
    error_message = <<-EOT
      Invalid resource manifest!
      The type of the property "${var.field_path}" must be bool.
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }


}
