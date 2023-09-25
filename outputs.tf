locals {
  yaml_files = flatten([
    for path in var.yamls : [
      for subfile in split("---", file(path)) :
      merge(yamldecode(subfile), {
        _metadata = {
          file = path
        }
      })
    ]
  ])

  manifests = [
    for yaml in local.yaml_files : {
      _metadata = {
        file = yaml._metadata.file
      }
      apiVersion = yaml.apiVersion
      kind       = yaml.kind
      metadata = {
        name = yaml.metadata.name
      }
      spec = yaml.spec
    }
  ]

  resource_manifests = [
    for manifest in local.manifests : manifest
    if !(manifest.apiVersion == "apiextensions.gapi.io/v1beta1" && manifest.kind == "CustomResourceDefinition")
  ]

  apiVersions = distinct([
    for resource in module.resources[*].manifest : resource.apiVersion
  ])

  kinds_by_apiVersion = {
    for apiVersion in local.apiVersions : apiVersion => distinct([
      for resource in module.resources[*].manifest : resource.kind
      if resource.apiVersion == apiVersion
    ])
  }
}

module "custom_resource_definition_v1beta1" {
  source = "./apis/apiextensions.gapi.io/v1beta1/CustomResourceDefinition/"

  manifests = [
    for manifest in local.manifests : manifest
    if manifest.apiVersion == "apiextensions.gapi.io/v1beta1" && manifest.kind == "CustomResourceDefinition"
  ]
}

module "resources" {
  source = "./validations/resource/"
  count  = length(local.resource_manifests)

  crds     = module.custom_resource_definition_v1beta1.crds
  manifest = local.resource_manifests[count.index]
}

output "resources" {
  value = {
    for apiVersion, kinds in local.kinds_by_apiVersion : apiVersion => {
      for kind in kinds : kind => {
        for resource in module.resources[*].manifest : resource.metadata.name => resource
        if resource.apiVersion == apiVersion && resource.kind == kind
      }
    }
  }
}
