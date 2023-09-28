locals {
  error_messages = {
    null_value   = <<-EOT
      Invalid resource manifest!
      The property "%s" can not be null.
      (metadata.name: "%s"; path: "%s")
    EOT
    invalid_value   = <<-EOT
      Invalid resource manifest!
      The type of the property "%s" must be bool.
      (metadata.name: "%s"; path: "%s")
    EOT
  }
}

output "value" {
  value = var.value

  precondition {
    condition = var.value != null
    error_message = format(
      local.error_messages.null_value,
      var.property,
      var.name,
      var.path,
    )
  }

  precondition {
    condition = can(tobool(var.value))
    error_message = format(
      local.error_messages.invalid_value,
      var.property,
      var.name,
      var.path,
    )
  }
}
