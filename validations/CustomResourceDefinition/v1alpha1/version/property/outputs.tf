locals {
  error_messages = {
    field_not_found       = <<-EOT
      Invalid "version" for CustomResourceDefinition!
      The property "%s.%s" are required.
      (metadata.name: "%s"; path: "%s")
    EOT
    invalid_property_type = <<-EOT
      Invalid "version" for CustomResourceDefinition!
      The type for the property "%s" must be one of %#v (got "%s").
      (metadata.name: "%s"; path: "%s")
    EOT
  }

  valid_types = ["string", "integer", "array", "object"]
  type        = try(var.options.type, "string")
}

output "options" {
  value = merge({
    description  = try(var.options.description, null)
    externalDocs = try(var.options.externalDocs, null)
  })

  precondition {
    condition = can(var.options.type)
    error_message = format(
      local.error_messages.field_not_found,
      var.property,
      "type",
      var.name,
      var.path,
    )
  }

  precondition {
    condition = contains(local.valid_types, local.type)
    error_message = format(
      local.error_messages.invalid_property_type,
      var.property,
      local.valid_types,
      local.type,
      var.name,
      var.path,
    )
  }
}
