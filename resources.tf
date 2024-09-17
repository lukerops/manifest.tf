locals {
  internal_manifests = [
    for output in module.manifests[*] : output
    if strcontains(output.manifest.apiVersion, "tf-gapi.lukerops.com") && output.manifest.kind == "CustomResourceDefinition"
  ]
  resource_manifests = [
    for output in module.manifests[*] : output
    if !strcontains(output.manifest.apiVersion, "tf-gapi.lukerops.com")
  ]
}

module "custom_resource_definitions" {
  source = "./CustomResourceDefinition"
  count  = length(local.internal_manifests)

  path     = local.internal_manifests[count.index].path
  manifest = local.internal_manifests[count.index].manifest
}

module "resources" {
  source = "./resourceValidation"
  count  = length(local.resource_manifests)

  path     = local.resource_manifests[count.index].path
  manifest = local.resource_manifests[count.index].manifest

  custom_resource_definitions = module.custom_resource_definitions[*].schema
}
