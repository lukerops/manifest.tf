locals {
  error_messages = {
    null_value      = <<-EOT
      Invalid resource manifest!
      The property "%s" can not be null.
      (metadata.name: "%s"; path: "%s")
    EOT
    invalid_value   = <<-EOT
      Invalid resource manifest!
      The type of the property "%s" must be string.
      (metadata.name: "%s"; path: "%s")
    EOT
    minLength_error = <<-EOT
      Invalid resource manifest!
      The minimum length of the property "%s" must be %v (got: %d).
      (metadata.name: "%s"; path: "%s")
    EOT
    maxLength_error = <<-EOT
      Invalid resource manifest!
      The maximum length of the property "%s" must be %v (got: %d).
      (metadata.name: "%s"; path: "%s")
    EOT
  }
}

output "value" {
  value = tostring(var.value)

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
    condition = can(tostring(var.value))
    error_message = format(
      local.error_messages.invalid_value,
      var.property,
      var.name,
      var.path,
    )
  }

  precondition {
    condition = try(length(var.value) >= var.schema.minLength, true)
    error_message = format(
      local.error_messages.minLength_error,
      var.property,
      var.schema.minLength,
      try(length(var.value), 0),
      var.name,
      var.path,
    )
  }

  precondition {
    condition = try(length(var.value) <= var.schema.maxLength, true)
    error_message = format(
      local.error_messages.maxLength_error,
      var.property,
      var.schema.maxLength,
      try(length(var.value), 0),
      var.name,
      var.path,
    )
  }
}
