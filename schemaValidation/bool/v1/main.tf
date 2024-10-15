output "resource" {
  value = try(tobool(var.manifest), null)

  precondition {
    condition     = var.manifest != null
    error_message = <<-EOT
      Invalid resource manifest!
      The property "${var.field_path}" can not be null.
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
