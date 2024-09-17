locals {
  apiVersionName = split("/", var.manifest.apiVersion)[1]
  apiGroup       = split("/", var.manifest.apiVersion)[0]

  api_versions = distinct(flatten([
    for crd in var.custom_resource_definitions : [
      for version in crd.versions : "${crd.group}/${version.name}"
    ]
  ]))
  kinds = distinct([for crd in var.custom_resource_definitions : crd.kind])

  matched_versions = flatten([
    for crd in var.custom_resource_definitions : [
      for name, version in crd.versions : merge(version, { path = crd.path })
      if name == local.apiVersionName
    ]
    if crd.group == local.apiGroup && crd.kind == var.manifest.kind
  ])
  version = try(one(local.matched_versions), null)
}

module "root_object" {
  source = "../schemaValidation/root_object"
  count  = local.version != null ? 1 : 0

  metadata_name = var.manifest.metadata.name
  path          = var.path
  field_path    = "spec"
  manifest      = var.manifest.spec
  schema        = local.version.schema
}

check "deprecated_version" {
  assert {
    condition     = try(!local.version.enabled || !local.version.deprecated, true)
    error_message = <<-EOT
      The apiVersion "${var.manifest.apiVersion}" of the CustomResourceDefinition (path: "${try(local.version.path, "")}") is marked as deprecated.
      Support for this version will be removed in future releases.
      (metadata.name: "${var.manifest.metadata.name}"; path: "${var.path}")
    EOT
  }
}

output "instance" {
  value = {
    path = var.path

    apiVersionName = local.apiVersionName
    apiGroup       = local.apiGroup

    apiVersion = var.manifest.apiVersion
    kind = var.manifest.kind
    metadata = {
      name = var.manifest.metadata.name
    }

    spec = one(module.root_object[*].resource)
  }

  precondition {
    condition     = length(local.matched_versions) < 2
    error_message = <<-EOT
      Found a duplicated CustomResourceDefinition in the files "${join("\", \"", local.matched_versions[*].path)}".
      (metadata.name: "${var.manifest.metadata.name}"; path: "${var.path}")
    EOT
  }

  precondition {
    condition     = local.version != null
    error_message = <<-EOT
      Invalid resource manifest!
      Can not found a matched CustomResourceDefinition with the apiVersion "${var.manifest.apiVersion}" and kind "${var.manifest.kind}".
      (metadata.name: "${var.manifest.metadata.name}"; path: "${var.path}")
    EOT
  }

  precondition {
    condition     = can(index(local.api_versions, var.manifest.apiVersion))
    error_message = <<-EOT
      Invalid resource manifest!
      apiVersion "${var.manifest.apiVersion}" not found. Available apiVersions are "${join("\", \"", local.api_versions)}".
      (metadata.name: "${var.manifest.metadata.name}"; path: "${var.path}")
    EOT
  }

  precondition {
    condition     = can(index(local.kinds, var.manifest.kind))
    error_message = <<-EOT
      Invalid resource manifest!
      kind "${var.manifest.kind}" not found. Available kinds are "${join("\", \"", local.kinds)}".
      (metadata.name: "${var.manifest.metadata.name}"; path: "${var.path}")
    EOT
  }

  precondition {
    condition     = try(local.version.enabled || local.version.deprecated, true)
    error_message = <<-EOT
      The apiVersion "${var.manifest.apiVersion}" of the CustomResourceDefinition (path: "${try(local.version.path, "")}") is marked as disabled.
      (metadata.name: "${var.manifest.metadata.name}"; path: "${var.path}")
    EOT
  }

  precondition {
    condition     = try(local.version.enabled || !local.version.deprecated, true)
    error_message = <<-EOT
      The apiVersion "${var.manifest.apiVersion}" of the CustomResourceDefinition (path: "${try(local.version.path, "")}") is marked as deprecated. Please update.
      (metadata.name: "${var.manifest.metadata.name}"; path: "${var.path}")
    EOT
  }
}
