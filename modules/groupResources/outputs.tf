locals {
  apiGroups = distinct([
    for resource in var.resources : resource.apiGroup
  ])
}

module "kinds" {
  source = "./groupByKind/"
  for_each = toset(local.apiGroups)

  apiGroup = each.key
  resources = var.resources
}

output "groupedResources" {
  value = {
    for apiGroup, result in module.kinds : apiGroup => result.kinds
  }
}
