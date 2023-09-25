locals {
  error_messages = {
    apiVersion_not_found = <<-EOT
      Invalid resource manifest!
      apiVersion "%s" not found. Available apiVersions are %#v.
      (metadata.name: %s; file: %s)
    EOT
    kind_not_found       = <<-EOT
      Invalid resource manifest!
      kind "%s" not found. Available kinds are %#v.
      (metadata.name: %s; file: %s)
    EOT
    property_not_defined = <<-EOT
      Invalid resource manifest!
      The properties %#v are not defined in the CustomResourceManifest.
      (metadata.name: %s; file: %s)
    EOT
  }

  crd = try(var.crds[var.manifest.apiVersion][var.manifest.kind], {
    properties = {}
  })
  integer_properties = {
    for property, options in local.crd.properties : property => options
    if options.type == "integer"
  }
  string_properties = {
    for property, options in local.crd.properties : property => options
    if options.type == "string"
  }
  array_properties = {
    for property, options in local.crd.properties : property => options
    if options.type == "array"
  }
  object_properties = {
    for property, options in local.crd.properties : property => options
    if options.type == "object"
  }

  extra_properties = setsubtract(keys(var.manifest.spec), keys(local.crd.properties))
}

module "string" {
  source   = "./string/"
  for_each = local.string_properties

  file          = var.manifest._metadata.file
  metadata_name = var.manifest.metadata.name

  property_path  = each.key
  property       = each.value
  manifest_value = try(var.manifest.spec[each.key], null)
}

module "integer" {
  source   = "./integer/"
  for_each = local.integer_properties

  file          = var.manifest._metadata.file
  metadata_name = var.manifest.metadata.name

  property_path  = each.key
  property       = each.value
  manifest_value = try(var.manifest.spec[each.key], null)
}

module "object" {
  source   = "./object/"
  for_each = local.object_properties

  file          = var.manifest._metadata.file
  metadata_name = var.manifest.metadata.name

  property_path  = each.key
  property       = each.value
  manifest_value = try(var.manifest.spec[each.key], null)
}

module "array" {
  source   = "./array/"
  for_each = local.array_properties

  file          = var.manifest._metadata.file
  metadata_name = var.manifest.metadata.name

  property_path  = each.key
  property       = each.value
  manifest_value = try(var.manifest.spec[each.key], null)
}

output "manifest" {
  value = {
    _metadata = {
      file = var.manifest._metadata.file
    }

    apiVersion = var.manifest.apiVersion
    kind       = var.manifest.kind

    metadata = {
      name = var.manifest.metadata.name
    }

    spec = {
      for property, value in merge(module.integer, module.string, module.object, module.array) :
      property => value.manifest_value
    }
  }

  precondition {
    condition = can(var.crds[var.manifest.apiVersion])
    error_message = format(
      local.error_messages.apiVersion_not_found,
      var.manifest.apiVersion,
      keys(var.crds),
      var.manifest.metadata.name,
      var.manifest._metadata.file,
    )
  }

  precondition {
    condition = !(can(var.crds[var.manifest.apiVersion]) && !can(var.crds[var.manifest.apiVersion][var.manifest.kind]))
    error_message = format(
      local.error_messages.kind_not_found,
      var.manifest.kind,
      try(keys(var.crds[var.manifest.apiVersion]), []),
      var.manifest.metadata.name,
      var.manifest._metadata.file,
    )
  }

  precondition {
    condition = length(local.extra_properties) == 0
    error_message = format(
      local.error_messages.property_not_defined,
      local.extra_properties,
      var.manifest.metadata.name,
      var.manifest._metadata.file,
    )
  }
}
