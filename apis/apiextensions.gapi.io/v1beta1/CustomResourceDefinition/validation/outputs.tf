locals {
  error_messages = {
    invalid_metadata_name = <<-EOT
      Invalid "metadata.name" of CustomResourceDefinition "%s"!
      The name must be in the form "<plural>.<group>".
      (kind: %s; file: %s)
    EOT
    kind_camel_case       = <<-EOT
      Invalid "names.kind" of CustomResourceDefinition "%s"!
      The kind must be CamelCased.
      (kind: %s; file: %s)
    EOT
    invalid_scope         = <<-EOT
      Invalid scope for CustomResourceDefinition "%s"!
      The scope must be "global".
      (kind: %s; file: %s)
    EOT
  }

  kind_first_letter = substr(var.manifest.spec.names.kind, 0, 1)
}

module "version" {
  source = "./version/"
  count  = length(var.manifest.spec.versions)

  file          = var.manifest._metadata.file
  metadata_name = var.manifest.metadata.name
  crd_kind      = var.manifest.kind
  crd_version   = var.manifest.spec.versions[count.index]
}

output "manifest" {
  value = var.manifest

  precondition {
    condition = var.manifest.metadata.name == join(".", [var.manifest.spec.names.plural, var.manifest.spec.group])
    error_message = format(
      local.error_messages.invalid_metadata_name,
      var.manifest.metadata.name,
      var.manifest.spec.names.kind,
      var.manifest._metadata.file,
    )
  }

  precondition {
    condition = local.kind_first_letter == upper(local.kind_first_letter)
    error_message = format(
      local.error_messages.kind_camel_case,
      var.manifest.metadata.name,
      var.manifest.spec.names.kind,
      var.manifest._metadata.file,
    )
  }

  precondition {
    condition = contains(["global"], var.manifest.spec.scope)
    error_message = format(
      local.error_messages.invalid_scope,
      var.manifest.metadata.name,
      var.manifest.spec.names.kind,
      var.manifest._metadata.file,
    )
  }

  depends_on = [ 
    module.version,
  ]
}
