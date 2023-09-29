locals {
  error_messages = {
    null_value     = <<-EOT
      Invalid resource manifest!
      The property "%s" can not be null.
      (metadata.name: "%s"; path: "%s")
    EOT
    invalid_value  = <<-EOT
      Invalid resource manifest!
      The type of the property "%s" must be list.
      (metadata.name: "%s"; path: "%s")
    EOT
    minItems_error = <<-EOT
      Invalid resource manifest!
      The minimum items of the property "%s" must be %v (got: %d).
      (metadata.name: "%s"; path: "%s")
    EOT
    maxItems_error = <<-EOT
      Invalid resource manifest!
      The maximum items of the property "%s" must be %v (got: %d).
      (metadata.name: "%s"; path: "%s")
    EOT
  }
}

module "property" {
  source = "./property/"
  count  = try(length(var.value), 0)

  path     = var.path
  name     = var.name
  property = "${var.property}[${count.index}]"
  schema   = var.schema.items
  value    = var.value[count.index]
}

output "value" {
  value = module.property[*].value

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
    condition = can(tolist(var.value))
    error_message = format(
      local.error_messages.invalid_value,
      var.property,
      var.name,
      var.path,
    )
  }

  precondition {
    condition = try(length(var.value) >= var.schema.minItems, true)
    error_message = format(
      local.error_messages.minItems_error,
      var.property,
      var.schema.minItems,
      try(length(var.value), 0),
      var.name,
      var.path,
    )
  }

  precondition {
    condition = try(length(var.value) <= var.schema.maxItems, true)
    error_message = format(
      local.error_messages.maxItems_error,
      var.property,
      var.schema.maxItems,
      try(length(var.value), 0),
      var.name,
      var.path,
    )
  }
}
