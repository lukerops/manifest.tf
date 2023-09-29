module "groupResources" {
  source = "./modules/groupResources/"

  resources = module.resources[*].instance
}

output "resources" {
  value = module.groupResources.groupedResources
}
