output "resources" {
  value = {
    for resource in var.resources : resource.metadata.name => resource
    if resource.apiGroup == var.apiGroup && resource.kind == var.kind
  }
}
