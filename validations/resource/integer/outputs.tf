locals {
  error_messages = {
    minimum_error = <<-EOT
      Invalid value for the property "%s"!
      The minimum value accepted are %v (got %v).
      (metadata.name: %s; property: %s; file: %s)
    EOT
    maximum_error = <<-EOT
      Invalid value for the property "%s"!
      The maximum value accepted are %v (got %v).
      (metadata.name: %s; property: %s; file: %s)
    EOT
    required_param = <<-EOT
      The property "%s" are required!
      (metadata.name: %s; property: %s; file: %s)
    EOT
  }

  value_is_null = var.manifest_value == null
  minimum_is_null = var.property.minimum == null
  maximum_is_null = var.property.maximum == null

  value = local.value_is_null ? 0 : var.manifest_value
  minimum = local.value_is_null || local.minimum_is_null ? true : local.value >= var.property.minimum
  maximum = local.value_is_null || local.maximum_is_null ? true : local.value <= var.property.maximum
  required = var.property.required ? var.manifest_value != null : true
}

output "manifest_value" {
  value = var.manifest_value == null ? var.property.default : var.manifest_value

  precondition {
    condition = local.minimum
    error_message = format(
      local.error_messages.minimum_error,
      var.property_path,
      var.property.minimum,
      var.manifest_value,
      var.metadata_name,
      var.property_path,
      var.file,
    )
  }

  precondition {
    condition = local.maximum
    error_message = format(
      local.error_messages.maximum_error,
      var.property_path,
      var.property.maximum,
      var.manifest_value,
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
