locals {
  error_messages = {
    root_property_is_not_object = <<-EOT

    EOT
  }
}

module "strint" {
  source = "./strint/"

  for_each = {
    for property, options in var.crd_version.schema.openAPIV3Schema.properties : property => options
    if !contains(["array", "object"], options.type)
  }

  file          = var.file
  metadata_name = var.metadata_name
  crd_kind      = var.crd_kind
  crd_version   = var.crd_version.name

  property      = each.value
  property_path = each.key
}

module "array" {
  source = "./array/"

  for_each = {
    for property, options in var.crd_version.schema.openAPIV3Schema.properties : property => options
    if options.type == "array"
  }

  file          = var.file
  metadata_name = var.metadata_name
  crd_kind      = var.crd_kind
  crd_version   = var.crd_version.name

  property      = each.value
  property_path = each.key
}

module "object" {
  source = "./object/"

  for_each = {
    for property, options in var.crd_version.schema.openAPIV3Schema.properties : property => options
    if options.type == "object"
  }

  file          = var.file
  metadata_name = var.metadata_name
  crd_kind      = var.crd_kind
  crd_version   = var.crd_version.name

  property      = each.value
  property_path = each.key
}

output "crd_version" {
  value = var.crd_version

  depends_on = [
    module.strint,
    module.array,
    module.object,
  ]
}
