locals {
  yamls = flatten([
    for path in var.yamls : [
      for subfile in split("\n---\n", file(path)) : {
        path = path
        file = subfile
      }
      if length(subfile) > 0
    ]
  ])
}

module "manifests" {
  source = "./manifestValidation"
  count  = length(local.yamls)

  path = local.yamls[count.index].path
  text = local.yamls[count.index].file
}
