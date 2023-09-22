locals {
  error_messages = {
    properties_not_set = <<-EOT
      Invalid property options for CustomResourceDefinition "%s"!
      At least 1 subproperty is needed for property of type "object".
      (property: %s; version: %s; kind: %s; file: %s)
    EOT
    invalid_options    = <<-EOT
      Invalid property options for CustomResourceDefinition "%s"!
      Only the options %#v must be set for property of type "%s".
      (property: %s; version: %s; kind: %s; file: %s)
    EOT
  }

  object_options = ["type", "description", "externalDocs", "required", "default", "properties"]
  property_options = [
    for option, value in var.property : value == null
    if !contains(local.object_options, option)
  ]

  properties_length = length(try(keys(var.property.properties), []))
}

module "strint" {
  source   = "../strint/"
  for_each = var.property.properties != null ? var.property.properties : {}

  file          = var.file
  metadata_name = var.metadata_name
  crd_kind      = var.crd_kind
  crd_version   = var.crd_version

  property      = each.value
  property_path = "${var.property_path}.${each.key}"

  is_object = true
}

output "property" {
  value = var.property

  precondition {
    condition = alltrue(local.property_options)
    error_message = format(
      local.error_messages.invalid_options,
      var.metadata_name,
      local.object_options,
      var.property.type,
      var.property_path,
      var.crd_version,
      var.crd_kind,
      var.file,
    )
  }

  precondition {
    condition = local.properties_length > 0
    error_message = format(
      local.error_messages.properties_not_set,
      var.metadata_name,
      var.property_path,
      var.crd_version,
      var.crd_kind,
      var.file,
    )
  }

  depends_on = [
    module.strint,
  ]
}
