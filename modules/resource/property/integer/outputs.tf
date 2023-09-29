locals {
  error_messages = {
    null_value    = <<-EOT
      Invalid resource manifest!
      The property "%s" can not be null.
      (metadata.name: "%s"; path: "%s")
    EOT
    invalid_value = <<-EOT
      Invalid resource manifest!
      The type of the property "%s" must be integer.
      (metadata.name: "%s"; path: "%s")
    EOT
    minimum_error = <<-EOT
      Invalid resource manifest!
      The minimum of the property "%s" must be %v (got: %v).
      (metadata.name: "%s"; path: "%s")
    EOT
    maximum_error = <<-EOT
      Invalid resource manifest!
      The maximum of the property "%s" must be %v (got: %v).
      (metadata.name: "%s"; path: "%s")
    EOT
  }
}

output "value" {
  value = tonumber(var.value)

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
    condition = can(tonumber(var.value))
    error_message = format(
      local.error_messages.invalid_value,
      var.property,
      var.name,
      var.path,
    )
  }

  precondition {
    condition = try(var.value >= var.schema.minimum, true)
    error_message = format(
      local.error_messages.minimum_error,
      var.property,
      var.schema.minimum,
      var.value,
      var.name,
      var.path,
    )
  }

  precondition {
    condition = try(var.value <= var.schema.maximum, true)
    error_message = format(
      local.error_messages.maximum_error,
      var.property,
      var.schema.maximum,
      var.value,
      var.name,
      var.path,
    )
  }
}
