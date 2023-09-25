locals {
  error_messages = {
    min_items_error = <<-EOT
      Invalid array size for the property "%s"!
      The minimum size accepted are %v (got %d).
      (metadata.name: %s; property: %s; file: %s)
    EOT
    max_items_error = <<-EOT
      Invalid array size for the property "%s"!
      The maximum size accepted are %v (got %d).
      (metadata.name: %s; property: %s; file: %s)
    EOT
    required_param  = <<-EOT
      The property "%s" are required!
      (metadata.name: %s; property: %s; file: %s)
    EOT
  }

  value_is_null     = var.manifest_value == null
  min_items_is_null = var.property.minItems == null
  max_items_is_null = var.property.maxItems == null

  value     = local.value_is_null ? [] : var.manifest_value
  min_items = local.value_is_null || local.min_items_is_null ? true : length(local.value) >= var.property.minItems
  max_items = local.value_is_null || local.max_items_is_null ? true : length(local.value) <= var.property.maxItems
  required  = var.property.required ? var.manifest_value != null : true
}

module "string" {
  source = "../string/"
  count  = try(var.property.items.type == "string", false) ? try(length(var.manifest_value), 0) : 0

  file          = var.file
  metadata_name = var.metadata_name

  property       = var.property.items
  property_path  = "${var.property_path}[${count.index}]"
  manifest_value = var.manifest_value[count.index]
}

module "integer" {
  source   = "../integer/"
  count  = try(var.property.items.type == "integer", false) ? try(length(var.manifest_value), 0) : 0

  file          = var.file
  metadata_name = var.metadata_name

  property       = var.property.items
  property_path  = "${var.property_path}[${count.index}]"
  manifest_value = var.manifest_value[count.index]
}

module "object" {
  source   = "../object/"
  count  = try(var.property.items.type == "object", false) ? try(length(var.manifest_value), 0) : 0

  file          = var.file
  metadata_name = var.metadata_name

  property       = var.property.items
  property_path  = "${var.property_path}[${count.index}]"
  manifest_value = var.manifest_value[count.index]
}

output "manifest_value" {
  value = var.manifest_value == null ? var.property.default : [
    for value in concat(module.string, module.integer, module.object) : value.manifest_value
  ]

  precondition {
    condition = local.min_items
    error_message = format(
      local.error_messages.min_items_error,
      var.property_path,
      var.property.minItems,
      length(local.value),
      var.metadata_name,
      var.property_path,
      var.file,
    )
  }

  precondition {
    condition = local.max_items
    error_message = format(
      local.error_messages.max_items_error,
      var.property_path,
      var.property.maxItems,
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
