locals {
  error_messages = {
    items_not_set   = <<-EOT
      Invalid property options for CustomResourceDefinition "%s"!
      The subproperty "items" is needed for property of type "array".
      (property: %s; version: %s; kind: %s; file: %s)
    EOT
    invalid_options = <<-EOT
      Invalid property options for CustomResourceDefinition "%s"!
      Only the options %#v must be set for property of type "%s".
      (property: %s; version: %s; kind: %s; file: %s)
    EOT
  }

  array_options = ["type", "description", "externalDocs", "required", "default", "maxItems", "minItems", "items"]
  property_options = [
    for option, value in var.property : value == null
    if !contains(local.array_options, option)
  ]
}

module "strint" {
  source   = "../strint/"
  count = try(var.property.items.type != "object", false) ? 1 : 0

  file          = var.file
  metadata_name = var.metadata_name
  crd_kind      = var.crd_kind
  crd_version   = var.crd_version

  property      = var.property.items
  property_path = "${var.property_path}"

  is_list = true
}

module "object" {
  source   = "../object/"
  count = try(var.property.items.type == "object", false) ? 1 : 0

  file          = var.file
  metadata_name = var.metadata_name
  crd_kind      = var.crd_kind
  crd_version   = var.crd_version

  property      = var.property.items
  property_path = "${var.property_path}"
}

output "property" {
  value = var.property

  precondition {
    condition = alltrue(local.property_options)
    error_message = format(
      local.error_messages.invalid_options,
      var.metadata_name,
      local.array_options,
      var.property.type,
      var.property_path,
      var.crd_version,
      var.crd_kind,
      var.file,
    )
  }

  precondition {
    condition = can(var.property.items.type)
    error_message = format(
      local.error_messages.items_not_set,
      var.metadata_name,
      var.property_path,
      var.crd_version,
      var.crd_kind,
      var.file,
    )
  }

  depends_on = [
    module.strint,
    module.object,
  ]
}
