module "string" {
  source = "./string/"
  count  = var.schema.type == "string" ? 1 : 0

  path     = var.path
  name     = var.name
  property = var.property
  schema   = var.schema
  value    = var.value
}

module "integer" {
  source = "./integer/"
  count  = var.schema.type == "integer" ? 1 : 0

  path     = var.path
  name     = var.name
  property = var.property
  schema   = var.schema
  value    = var.value
}

output "value" {
  value = coalesce(concat(
    module.string[*].value,
    module.integer[*].value,
  )...)
}
