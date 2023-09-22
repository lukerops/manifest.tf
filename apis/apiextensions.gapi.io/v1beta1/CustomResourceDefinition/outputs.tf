locals {
  crds = flatten([
    for manifest in module.validation[*].manifest : [
      for version in manifest.spec.versions : {
        _metadata = {
          file = manifest._metadata.file
        }
        apiVersion = join("/", [manifest.spec.group, version.name])
        kind       = manifest.spec.names.kind
        scope      = manifest.spec.scope
        properties = version.schema.properties
      }
      if version.served
    ]
  ])

  apiVersions = distinct([
    for crd in local.crds : crd.apiVersion
  ])

  grouped_crds = {
    for apiVersion in local.apiVersions : apiVersion => {
      for crd in local.crds : (crd.kind) => crd
      if crd.apiVersion == apiVersion
    }
  }
}

module "validation" {
  source = "./validation/"
  count  = length(var.manifests)

  manifest = var.manifests[count.index]
}

output "crds" {
  value = local.grouped_crds
}
