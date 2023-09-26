locals {
  yamls = flatten([
    for path in var.yamls : [
      for subfile in split("---", file(path)) : {
        path = path
        file = subfile
      }
    ]
  ])
}

module "manifests" {
  source = "./validations/manifest/"
  count  = length(local.yamls)

  path     = local.yamls[count.index].path
  manifest = local.yamls[count.index].file
}
