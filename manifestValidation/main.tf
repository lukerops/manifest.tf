locals {
  manifest = try(yamldecode(var.text), null)
}

output "path" {
  value = var.path
}

output "manifest" {
  value = local.manifest

  precondition {
    condition     = local.manifest != null
    error_message = <<-EOT
      The file are not an valid YAML.
      (path: "${var.path})
    EOT
  }

  precondition {
    condition     = local.manifest == null || can(local.manifest.apiVersion)
    error_message = <<-EOT
      Invalid manifest!
      The "apiVersion" field are required.
      (path: "${var.path})
    EOT
  }

  precondition {
    condition     = local.manifest == null || !can(local.manifest.apiVersion) || try(length(split("/", local.manifest.apiVersion)) == 2, true)
    error_message = <<-EOT
      Invalid manifest apiVersion!
      The "apiVersion" field must be in the format "`apiGroup`/`apiVersionName`".
      (path: "${var.path})
    EOT
  }

  precondition {
    condition     = local.manifest == null || can(local.manifest.kind)
    error_message = <<-EOT
      Invalid manifest!
      The "kind" field are required.
      (path: "${var.path})
    EOT
  }

  precondition {
    condition     = local.manifest == null || can(local.manifest.metadata)
    error_message = <<-EOT
      Invalid manifest!
      The "metadata" field are required.
      (path: "${var.path})
    EOT
  }

  precondition {
    condition     = local.manifest == null || !can(local.manifest.metadata) || can(local.manifest.metadata.name)
    error_message = <<-EOT
      Invalid manifest!
      The "metadata.name" field are required.
      (path: "${var.path})
    EOT
  }

  precondition {
    condition     = local.manifest == null || can(local.manifest.spec)
    error_message = <<-EOT
      Invalid manifest!
      The "spec" field are required.
      (path: "${var.path})
    EOT
  }
}
