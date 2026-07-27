locals {
  optional   = var.schema.validations.optional
  properties = keys(var.schema.subItem)
  missing_properties = [
    for property in local.properties : property
    if !can(var.manifest[property])
    && !try(var.schema.subItem[property].validations.has_default_value, false)
  ]
}

module "string" {
  source   = "../../../../schemaValidation/string"
  for_each = { for k, v in var.schema.subItem : k => v if v.type == "string" && !contains(local.missing_properties, k) }

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}.${each.key}"
  manifest      = try(var.manifest[each.key], null)
  schema        = each.value
}

module "integer" {
  source   = "../../../../schemaValidation/integer"
  for_each = { for k, v in var.schema.subItem : k => v if v.type == "integer" && !contains(local.missing_properties, k) }

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}.${each.key}"
  manifest      = try(var.manifest[each.key], null)
  schema        = each.value
}

module "bool" {
  source   = "../../../../schemaValidation/bool"
  for_each = { for k, v in var.schema.subItem : k => v if v.type == "bool" && !contains(local.missing_properties, k) }

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}.${each.key}"
  manifest      = try(var.manifest[each.key], null)
  schema        = each.value
}

module "array" {
  source   = "../../../../schemaValidation/array"
  for_each = { for k, v in var.schema.subItem : k => v if v.type == "array" && !contains(local.missing_properties, k) }

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}.${each.key}"
  manifest      = try(var.manifest[each.key], null)
  schema        = each.value
}

module "reduced_object" {
  source   = "../../../../schemaValidation/reduced_object"
  for_each = { for k, v in var.schema.subItem : k => v if v.type == "reduced_object" && !contains(local.missing_properties, k) }

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}.${each.key}"
  manifest      = try(var.manifest[each.key], null)
  schema        = each.value
}

output "resource" {
  value = var.manifest != null ? { for k, v in merge(module.string, module.integer, module.bool, module.array, module.reduced_object) : k => v.resource } : null

  precondition {
    condition     = var.manifest != null || local.optional
    error_message = <<-EOT
      Invalid resource manifest!
      The property "${var.field_path}" can not be null (and is not optional).
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }

  precondition {
    condition     = var.manifest == null || can(keys(var.manifest))
    error_message = <<-EOT
      Invalid resource manifest!
      The type of the property "${var.field_path}" must be object.
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }

  precondition {
    condition     = var.manifest == null || length(local.missing_properties) == 0
    error_message = <<-EOT
      Invalid resource manifest!
      The field "${var.field_path}" is missing the following properties: ${join(", ", local.missing_properties)}.
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }
}
