module "v0" {
  source = "../../schemaProcessor/reduced_array/v0/validator/"
  count  = var.schema.version == "v0" ? 1 : 0

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = var.field_path
  manifest      = var.manifest
  schema        = var.schema
}

module "v2" {
  source = "../../schemaProcessor/reduced_array/v2/validator/"
  count  = var.schema.version == "v2" ? 1 : 0

  metadata_name = var.metadata_name
  path          = var.path
  field_path    = var.field_path
  manifest      = var.manifest
  schema        = var.schema
}

output "resource" {
  value = one(
    concat(
      module.v0[*].resource,
      module.v2[*].resource,
    )
  )
}
