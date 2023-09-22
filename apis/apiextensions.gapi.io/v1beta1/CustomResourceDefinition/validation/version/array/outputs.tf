locals {
  error_messages = {
    items_not_set   = <<-EOT
      Invalid property options for CustomResourceDefinition "%s"!
      At least 1 item is needed for property of type "array".
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

  strint_items = {
    for index, item in var.property.items : index => item
    if item.type != "object"
  }
  object_items = {
    for index, item in var.property.items : index => item
    if item.type == "object"
  }
}

module "strint" {
  source   = "../strint/"
  for_each = local.strint_items

  file          = var.file
  metadata_name = var.metadata_name
  crd_kind      = var.crd_kind
  crd_version   = var.crd_version

  property      = each.value
  property_path = "${var.property_path}[${each.key}]"

  is_list = true
}

module "object" {
  source   = "../object/"
  for_each = local.object_items

  file          = var.file
  metadata_name = var.metadata_name
  crd_kind      = var.crd_kind
  crd_version   = var.crd_version

  property      = each.value
  property_path = "${var.property_path}[${each.key}]"
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
    condition = length(var.property.items) > 0
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
