locals {
  kinds = distinct([
    for resource in var.resources : resource.kind
    if resource.apiGroup == var.apiGroup
  ])
}

output "kinds" {
  value = {
    for kind, result in local.kinds : kind => {
      for resource in var.resources : resource.metadata.name => resource
      if resource.apiGroup == var.apiGroup && resource.kind == kind
    }
  }
}
