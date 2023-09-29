locals {
  error_messages = {
    null_value    = <<-EOT
      Invalid resource manifest!
      The property "%s" can not be null.
      (metadata.name: "%s"; path: "%s")
    EOT
    invalid_value = <<-EOT
      Invalid resource manifest!
      The type of the property "%s" must be object.
      (metadata.name: "%s"; path: "%s")
    EOT
  }
}

module "property" {
  source   = "./property/"
  for_each = toset(keys(var.schema.properties))

  path     = var.path
  name     = var.name
  property = "${var.property}.${each.key}"
  schema   = var.schema.properties[each.key]
  value    = try(var.value[each.key], null)
}

output "value" {
  value = {
    for property, result in module.property : property => result.value
  }

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
    condition = can(keys(var.value))
    error_message = format(
      local.error_messages.invalid_value,
      var.property,
      var.name,
      var.path,
    )
  }
}
