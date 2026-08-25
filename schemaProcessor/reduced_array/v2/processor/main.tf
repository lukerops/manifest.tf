locals {
  declared_default_field       = contains(keys(var.manifest), "default")
  has_compatible_default_value = can(tolist(try(var.manifest.default, null)))
}

module "string" {
  source = "../../../string/v1/processor"
  count  = try(var.manifest.items.type == "string", false) ? 1 : 0

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}.items"
  manifest      = var.manifest.items
}

module "integer" {
  source = "../../../integer/v1/processor"
  count  = try(var.manifest.items.type == "integer", false) ? 1 : 0

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}.items"
  manifest      = var.manifest.items
}

module "bool" {
  source = "../../../bool/v1/processor"
  count  = try(var.manifest.items.type == "bool", false) ? 1 : 0

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = "${var.field_path}.items"
  manifest      = var.manifest.items
}

output "schema" {
  value = {
    type    = "reduced_array"
    version = "v2"
    subItem = one(flatten([module.string[*].schema, module.integer[*].schema, module.bool[*].schema]))
    validations = {
      minItems          = try(tonumber(var.manifest.minItems), null)
      maxItems          = try(tonumber(var.manifest.maxItems), null)
      has_default_value = can(var.manifest.default) ? true : false
      default_value     = try(var.manifest.default, null)
    }
  }

  precondition {
    condition     = can(var.manifest.items)
    error_message = <<-EOT
      Invalid "items" value.
      The field "${var.field_path}.items" are required.
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = !can(var.manifest.items) || can(var.manifest.items.type)
    error_message = <<-EOT
      Invalid "items" value.
      The field "${var.field_path}.items.type" are required.
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = !can(var.manifest.items) || !can(var.manifest.items.type) || try(contains(["string", "integer", "bool"], var.manifest.items.type), true)
    error_message = <<-EOT
      Invalid "items.type" value.
      The field "${var.field_path}.items.type" must be one of "string", "integer" or "bool".
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = can(var.manifest.items.type)
    error_message = <<-EOT
      Invalid "items" value.
      The field "${var.field_path}.items.type" are required.
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = can(tonumber(try(var.manifest.minItems, null)))
    error_message = <<-EOT
      Invalid "minItems" value.
      The field "${var.field_path}.minItems" must be a number.
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = try(tonumber(var.manifest.minItems) >= 0, true)
    error_message = <<-EOT
      Invalid "minItems" value.
      The field "${var.field_path}.minItems" must be greater than or equal to 0.
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = can(tonumber(try(var.manifest.maxItems, null)))
    error_message = <<-EOT
      Invalid "maxItems" value.
      The field "${var.field_path}.maxItems" must be a number.
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = try(tonumber(var.manifest.maxItems) >= 1, true)
    error_message = <<-EOT
      Invalid "maxItems" value.
      The field "${var.field_path}.maxItems" must be greater than or equal to 1.
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = try(var.manifest.minItems < var.manifest.maxItems, true)
    error_message = <<-EOT
      Invalid "minItems" and "maxItems" values.
      The field "${var.field_path}.minItems" must be less than "${var.field_path}.maxItems".
      (metadata.name: "${var.metadata_name}", path: "${var.path}")
    EOT
  }

  precondition {
    condition     = !(local.declared_default_field && try(var.manifest.default, null) == null)
    error_message = <<-EOT
      Invalid Manifest!
      The default value of a reduced_array field can't be null.
      The field "${var.field_path}" has its default value set to null.
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }

  precondition {
    condition     = local.has_compatible_default_value
    error_message = <<-EOT
      Invalid resource manifest!
      The default value of the property "${var.field_path}" must be compatible with type array.
      Current default value: ${format("%v", try(var.manifest.default, "null"))}
      (metadata.name: "${var.metadata_name}"; path: "${var.path}")
    EOT
  }
}
