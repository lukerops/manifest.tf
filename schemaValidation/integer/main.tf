module "v0" {
  source = "./v0"
  count  = var.schema.version == "v0" ? 1 : 0

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = var.field_path
  manifest      = var.manifest
  schema        = var.schema
}

output "resource" {
  value = one(module.v0[*].resource)
}
