locals {
  error_messages = {
    required_param = <<-EOT
      The property "%s" are required!
      (metadata.name: %s; property: %s; file: %s)
    EOT
  }

  required = var.property.required ? var.manifest_value != null : true

  string_properties = {
    for property, options in var.property.properties : property => options
    if options.type == "string"
  }
  integer_properties = {
    for property, options in var.property.properties : property => options
    if options.type == "integer"
  }
}

module "string" {
  source   = "../string/"
  for_each = local.string_properties

  file          = var.file
  metadata_name = var.metadata_name

  property       = each.value
  property_path  = "${var.property_path}.${each.key}"
  manifest_value = try(var.manifest_value[each.key], null)
}

module "integer" {
  source   = "../integer/"
  for_each = local.integer_properties

  file          = var.file
  metadata_name = var.metadata_name

  property       = each.value
  property_path  = "${var.property_path}.${each.key}"
  manifest_value = try(var.manifest_value[each.key], null)
}

output "manifest_value" {
  value = var.manifest_value == null ? var.property.default : {
    for property, value in merge(module.string, module.integer) :
    property => value.manifest_value
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
