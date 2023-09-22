locals {
  error_messages = {
    invalid_type    = <<-EOT
      Invalid property type for CustomResourceDefinition "%s"!
      The property type must be %#v.
      (property: %s; version: %s; kind: %s; file: %s)
    EOT
    invalid_options = <<-EOT
      Invalid property options for CustomResourceDefinition "%s"!
      Only the options %#v must be set for property of type "%s".
      (property: %s; version: %s; kind: %s; file: %s)
    EOT
  }

  valid_types = {
    # is_list
    true = {
      # is_object
      true = ["string", "integer"]
      false = ["string", "integer", "object"]
    }
    false = {
      # is_object
      true = ["string", "integer"]
      false = ["string", "integer", "array", "object"]
    }
  }

  common_options = ["type", "description", "externalDocs", "required", "default"]
  options_per_type = {
    string  = ["pattern", "minLength", "maxLength"]
    integer = ["minimum", "maximum", "multipleOf"]
  }

  property_options = [
    for option, value in var.property : value == null
    if !contains(
      concat(
        local.common_options,
        try(local.options_per_type[var.property.type], []),
      ),
      option,
    )
  ]
}

output "property" {
  value = var.property

  precondition {
    condition = contains(["string", "integer"], var.property.type)
    error_message = format(
      local.error_messages.invalid_type,
      var.metadata_name,
      local.valid_types[var.is_list][var.is_object],
      var.property_path,
      var.crd_version,
      var.crd_kind,
      var.file,
    )
  }

  precondition {
    condition = !can(local.options_per_type[var.property.type]) || alltrue(local.property_options)
    error_message = format(
      local.error_messages.invalid_options,
      var.metadata_name,
      concat(
        local.common_options,
        try(local.options_per_type[var.property.type], []),
      ),
      var.property.type,
      var.property_path,
      var.crd_version,
      var.crd_kind,
      var.file,
    )
  }
}
