locals {
  error_messages = {
    min_length_error = <<-EOT
      Invalid length for the property "%s"!
      The minimum length accepted are %v (got %d).
      (metadata.name: %s; property: %s; file: %s)
    EOT
    max_length_error = <<-EOT
      Invalid length for the property "%s"!
      The maximum length accepted are %v (got %d).
      (metadata.name: %s; property: %s; file: %s)
    EOT
    required_param = <<-EOT
      The property "%s" are required!
      (metadata.name: %s; property: %s; file: %s)
    EOT
  }

  value_is_null = var.manifest_value == null
  min_length_is_null = var.property.minLength == null
  max_length_is_null = var.property.maxLength == null

  value = local.value_is_null ? "" : var.manifest_value
  min_lenght = local.value_is_null || local.min_length_is_null ? true : length(local.value) >= var.property.minLength
  max_lenght = local.value_is_null || local.max_length_is_null ? true : length(local.value) <= var.property.maxLength
  required = var.property.required ? var.manifest_value != null : true
}

output "manifest_value" {
  value = var.manifest_value == null ? var.property.default : var.manifest_value

  precondition {
    condition = local.min_lenght
    error_message = format(
      local.error_messages.min_length_error,
      var.property_path,
      var.property.minLength,
      length(local.value),
      var.metadata_name,
      var.property_path,
      var.file,
    )
  }

  precondition {
    condition = local.max_lenght
    error_message = format(
      local.error_messages.max_length_error,
      var.property_path,
      var.property.maxLength,
      length(local.value),
      var.metadata_name,
      var.property_path,
      var.file,
    )
  }

  precondition {
    condition = local.required
    error_message = format(
      local.error_messages.required_param,
      var.property_path,
      var.metadata_name,
      var.property_path,
      var.file,
    )
  }
}
