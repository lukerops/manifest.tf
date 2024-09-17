locals {
  minItems       = var.schema.validations.minItems != null ? var.schema.validations.minItems : 0
  maxItems       = var.schema.validations.maxItems != null ? var.schema.validations.maxItems : 0
  manifestLength = can(tolist(var.manifest)) ? try(length(var.manifest), 0) : 0
}

module "string" {
  source = "../../string/"
  count  = var.schema.subItem.type == "string" ? local.manifestLength : 0

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}[${count.index}]"
  manifest      = var.manifest[count.index]
  schema        = var.schema.subItem
}

module "bool" {
  source = "../../bool/"
  count  = var.schema.subItem.type == "bool" ? local.manifestLength : 0

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}[${count.index}]"
  manifest      = var.manifest[count.index]
  schema        = var.schema.subItem
}

module "integer" {
  source = "../../integer/"
  count  = var.schema.subItem.type == "integer" ? local.manifestLength : 0

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}[${count.index}]"
  manifest      = var.manifest[count.index]
  schema        = var.schema.subItem
}

module "reduced_object" {
  source = "../../reduced_object"
  count  = var.schema.subItem.type == "reduced_object" ? local.manifestLength : 0

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}[${count.index}]"
  manifest      = var.manifest[count.index]
  schema        = var.schema.subItem
}

output "resource" {
  value = concat(module.string[*].resource, module.bool[*].resource, module.integer[*].resource, module.reduced_object[*].resource)

  precondition {
    condition     = var.manifest != null
    error_message = <<-EOT
      Invalid resource manifest!
      The property "${var.field_path}" can not be null.
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }

  precondition {
    condition     = can(tolist(var.manifest))
    error_message = <<-EOT
      Invalid resource manifest!
      The type of the property "${var.field_path}" must be list.
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }

  precondition {
    condition     = try(length(var.manifest) >= var.schema.validations.minItems, true)
    error_message = <<-EOT
      Invalid resource manifest!
      The minimum items of the property "${var.field_path}" must be ${local.minItems} (got: ${local.manifestLength}).
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }

  precondition {
    condition     = try(length(var.manifest) <= var.schema.validations.maxItems, true)
    error_message = <<-EOT
      Invalid resource manifest!
      The minimum length of the property "${var.field_path}" must be ${local.maxItems} (got: ${local.manifestLength}).
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }
}
