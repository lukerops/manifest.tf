module "groupResources" {
  source = "./groupResources"

  resources = module.resources[*].instance
}

output "resources" {
  value = module.groupResources.groupedResources
}
