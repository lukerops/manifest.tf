locals {
  kinds = distinct([
    for resource in var.resources : resource.kind
    if resource.apiGroup == var.apiGroup
  ])
}

module "resources" {
  source   = "./resources/"
  for_each = toset(local.kinds)

  apiGroup  = var.apiGroup
  kind      = each.key
  resources = var.resources
}

output "kinds" {
  value = {
    for kind, result in module.resources : kind => result.resources
  }
}
