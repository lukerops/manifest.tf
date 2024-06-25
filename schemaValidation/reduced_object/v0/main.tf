module "string" {
  source   = "../../string"
  for_each = { for k, v in var.schema.subItem : k => v if v.type == "string" }

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}.${each.key}"
  manifest      = try(var.manifest[each.key], null)
  schema        = each.value
}

module "integer" {
  source   = "../../integer"
  for_each = { for k, v in var.schema.subItem : k => v if v.type == "integer" }

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}.${each.key}"
  manifest      = try(var.manifest[each.key], null)
  schema        = each.value
}

module "bool" {
  source   = "../../bool"
  for_each = { for k, v in var.schema.subItem : k => v if v.type == "bool" }

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}.${each.key}"
  manifest      = try(var.manifest[each.key], null)
  schema        = each.value
}

module "reduced_array" {
  source   = "../../reduced_array"
  for_each = { for k, v in var.schema.subItem : k => v if v.type == "reduced_array" }

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}.${each.key}"
  manifest      = try(var.manifest[each.key], null)
  schema        = each.value
}

locals {
  properties = keys(var.schema.subItem)
  missing_properties = [
    for property in local.properties : property
    if !can(var.manifest[property])
  ]
}

output "resource" {
  value = { for k, v in merge(module.string, module.integer, module.bool, module.reduced_array) : k => v.resource }

  precondition {
    condition     = var.manifest != null
    error_message = <<-EOT
      Invalid resource manifest!
      The property "${var.field_path}" can not be null.
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }

  precondition {
    condition     = can(keys(var.manifest))
    error_message = <<-EOT
      Invalid resource manifest!
      The type of the property "${var.field_path}" must be object.
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }

  precondition {
    condition     = length(local.missing_properties) == 0
    error_message = <<-EOT
      Invalid resource manifest!
      The field "${var.field_path}" is missing the following properties: ${join(", ", local.missing_properties)}.
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }
}
