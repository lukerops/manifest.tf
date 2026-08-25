locals {
  properties                    = try({ for key, value in var.manifest.properties : key => value }, {})
  declared_optional_field       = contains(keys(var.manifest), "optional")
  has_compatible_optional_value = can(tobool(try(var.manifest.optional, false)))
}

module "string" {
  source   = "../../../string/v1/processor"
  for_each = toset([for key, value in local.properties : key if try(value.type, null) == "string"])

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}.properties.${each.key}"
  manifest      = var.manifest.properties[each.key]
}

module "integer" {
  source   = "../../../integer/v1/processor"
  for_each = toset([for key, value in local.properties : key if try(value.type, null) == "integer"])

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}.properties.${each.key}"
  manifest      = var.manifest.properties[each.key]
}

module "bool" {
  source   = "../../../bool/v1/processor"
  for_each = toset([for key, value in local.properties : key if try(value.type, null) == "bool"])

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}.properties.${each.key}"
  manifest      = var.manifest.properties[each.key]
}

module "array" {
  source   = "../../../array/v2/processor"
  for_each = toset([for key, value in local.properties : key if try(value.type, null) == "array"])

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}.properties.${each.key}"
  manifest      = var.manifest.properties[each.key]
}

module "reduced_object" {
  source   = "../../../reduced_object/v2/processor"
  for_each = toset([for key, value in local.properties : key if try(value.type, null) == "object"])

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}.properties.${each.key}"
  manifest      = var.manifest.properties[each.key]
}

output "schema" {
  value = {
    type    = "object"
    version = "v2"
    validations = {
      optional = try(tobool(var.manifest.optional), false)
    }
    subItem = {
      for key, value in merge(module.string, module.integer, module.bool, module.array, module.reduced_object) : key => value.schema
    }
  }

  precondition {
    condition     = can(var.manifest.properties)
    error_message = <<-EOT
      Invalid object.
      The field "${var.field_path}.properties" are required.
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = !can(var.manifest.properties) || can(keys(var.manifest.properties))
    error_message = <<-EOT
      Invalid "properties" value.
      The field "${var.field_path}.properties" must be an object.
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = length([for key, value in local.properties : key if try(value.type, null) == null]) == 0
    error_message = <<-EOT
      Invalid "properties" value.
      The field "${var.field_path}.properties" must have a "type" field.
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition = alltrue([
      for key, value in local.properties : contains(["string", "integer", "bool", "array", "object"], value.type)
      if can(value.type)
    ])
    error_message = <<-EOT
      Invalid propertie "type".
      The field "${var.field_path}.properties.*.type" must be one of "string", "integer", "bool", "array" or "object".
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = local.has_compatible_optional_value
    error_message = <<-EOT
      Invalid "optional" value.
      The field "${var.field_path}.optional" must be a bool.
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = !(local.declared_optional_field && try(tobool(var.manifest.optional), false) && contains(keys(var.manifest), "default"))
    error_message = <<-EOT
      Invalid Manifest!
      The field "${var.field_path}" can't have both "optional: true" and "default" set.
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }
}
