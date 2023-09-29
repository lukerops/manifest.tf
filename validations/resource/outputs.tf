locals {
  error_messages = {
    apiVersion_not_found                  = <<-EOT
      Invalid resource manifest!
      apiVersion "%s" not found. Available apiVersions are %#v.
      (metadata.name: "%s"; path: "%s")
    EOT
    kind_not_found                        = <<-EOT
      Invalid resource manifest!
      kind "%s" not found. Available kinds are %#v.
      (metadata.name: "%s"; path: "%s")
    EOT
    duplicated_custom_resource_definition = <<-EOT
      Found a duplicated CustomResourceDefinition in the files %#v.
      (metadata.name: "%s"; path: "%s")
    EOT
    custom_resource_definition_not_found  = <<-EOT
      Invalid resource manifest!
      Can not found a matched CustomResourceDefinition with the apiVersion "%s" and kind "%s".
      (metadata.name: "%s"; path: "%s")
    EOT
    property_not_defined                  = <<-EOT
      Invalid resource manifest!
      The properties %#v are not defined in the CustomResourceDefinition (path: "%s").
      (metadata.name: "%s"; path: "%s")
    EOT
    disabled_version                      = <<-EOT
      The apiVersion "%s" of the CustomResourceDefinition (path: "%s") is marked as disabled.
      (metadata.name: "%s"; path: "%s")
    EOT
    deprecated_version                    = <<-EOT
      The apiVersion "%s" of the CustomResourceDefinition (path: "%s") is marked as deprecated. Please update.
      (metadata.name: "%s"; path: "%s")
    EOT
  }

  warning_messages = {
    deprecated_version = <<-EOT
      The apiVersion "%s" of the CustomResourceDefinition (path: "%s") is marked as deprecated. Support for this version will be removed in future releases.
      (metadata.name: "%s"; path: "%s")
    EOT
  }

  apiVersions = distinct([
    for crd in var.custom_resource_definitions : crd.apiVersion
  ])
  kinds = distinct([
    for crd in var.custom_resource_definitions : crd.kind
  ])
  matched = [
    for crd in var.custom_resource_definitions : crd
    if crd.apiVersion == var.manifest.apiVersion && crd.kind == var.manifest.kind
  ]
  crd = try(local.matched[0], {
    path       = ""
    enabled    = true
    deprecated = false
    specSchema = {}
  })

  extra_properties = setsubtract(keys(var.manifest.spec), keys(local.crd.specSchema))
}

module "property" {
  source   = "./property/"
  for_each = toset(keys(local.crd.specSchema))

  path     = var.manifest.path
  name     = var.manifest.metadata.name
  property = "spec.${each.key}"
  schema   = local.crd.specSchema[each.key]
  value    = try(var.manifest.spec[each.key], null)
}

check "deprecated_version" {
  assert {
    condition = !local.crd.enabled || !local.crd.deprecated
    error_message = format(
      local.warning_messages.deprecated_version,
      var.manifest.apiVersion,
      local.crd.path,
      var.manifest.metadata.name,
      var.manifest.path,
    )
  }
}

output "instance" {
  value = {
    path           = var.manifest.path
    apiGroup       = try(split("/", var.manifest.apiVersion)[0], "error")
    apiVersionName = try(split("/", var.manifest.apiVersion)[1], "error")
    apiVersion     = var.manifest.apiVersion
    kind           = var.manifest.kind
    metadata = {
      name = var.manifest.metadata.name
    }
    spec = {
      for property, result in module.property : property => result.value
    }
  }

  precondition {
    condition = can(index(local.apiVersions, var.manifest.apiVersion))
    error_message = format(
      local.error_messages.apiVersion_not_found,
      var.manifest.apiVersion,
      local.apiVersions,
      var.manifest.metadata.name,
      var.manifest.path,
    )
  }

  precondition {
    condition = can(index(local.kinds, var.manifest.kind))
    error_message = format(
      local.error_messages.kind_not_found,
      var.manifest.kind,
      local.kinds,
      var.manifest.metadata.name,
      var.manifest.path,
    )
  }

  precondition {
    condition = length(local.matched) <= 1
    error_message = format(
      local.error_messages.duplicated_custom_resource_definition,
      distinct([for crd in local.matched : crd.path]),
      var.manifest.metadata.name,
      var.manifest.path,
    )
  }

  precondition {
    condition = length(local.matched) >= 1
    error_message = format(
      local.error_messages.custom_resource_definition_not_found,
      var.manifest.apiVersion,
      var.manifest.kind,
      var.manifest.metadata.name,
      var.manifest.path,
    )
  }

  precondition {
    condition = length(local.extra_properties) == 0
    error_message = format(
      local.error_messages.property_not_defined,
      local.extra_properties,
      local.crd.path,
      var.manifest.metadata.name,
      var.manifest.path,
    )
  }

  precondition {
    condition = local.crd.enabled || local.crd.deprecated
    error_message = format(
      local.error_messages.disabled_version,
      var.manifest.apiVersion,
      local.crd.path,
      var.manifest.metadata.name,
      var.manifest.path,
    )
  }

  precondition {
    condition = local.crd.enabled || !local.crd.deprecated
    error_message = format(
      local.error_messages.deprecated_version,
      var.manifest.apiVersion,
      local.crd.path,
      var.manifest.metadata.name,
      var.manifest.path,
    )
  }
}
