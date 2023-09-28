locals {
  error_messages = {
    file_does_not_yaml = <<-EOT
      The file are not an valid YAML.
      (path: "%s")
    EOT
    field_not_found    = <<-EOT
      Invalid manifest!
      The "%s" field are required.
      (path: "%s")
    EOT
  }

  manifest = try(
    merge(yamldecode(var.manifest), { path = var.path }),
    null,
  )

  is_null = local.manifest == null
}

output "manifest" {
  value = local.manifest

  precondition {
    condition = !local.is_null
    error_message = format(
      local.error_messages.file_does_not_yaml,
      var.path,
    )
  }

  precondition {
    condition = local.is_null || can(local.manifest.apiVersion)
    error_message = format(
      local.error_messages.field_not_found,
      "apiVersion",
      var.path,
    )
  }

  precondition {
    condition = local.is_null || can(local.manifest.kind)
    error_message = format(
      local.error_messages.field_not_found,
      "kind",
      var.path,
    )
  }

  precondition {
    condition = local.is_null || can(local.manifest.metadata)
    error_message = format(
      local.error_messages.field_not_found,
      "metadata",
      var.path,
    )
  }

  precondition {
    condition = local.is_null || can(local.manifest.metadata.name)
    error_message = format(
      local.error_messages.field_not_found,
      "metadata.name",
      var.path,
    )
  }

  precondition {
    condition = local.is_null || can(local.manifest.spec)
    error_message = format(
      local.error_messages.field_not_found,
      "spec",
      var.path,
    )
  }
}
