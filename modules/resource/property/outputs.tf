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

module "bool" {
  source = "./bool/"
  count  = var.schema.type == "bool" ? 1 : 0

  path     = var.path
  name     = var.name
  property = var.property
  schema   = var.schema
  value    = var.value
}

module "object" {
  source = "./object/"
  count  = var.schema.type == "object" ? 1 : 0

  path     = var.path
  name     = var.name
  property = var.property
  schema   = var.schema
  value    = var.value
}

module "array" {
  source = "./array/"
  count  = var.schema.type == "array" ? 1 : 0

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
    module.bool[*].value,
    module.object[*].value,
    module.array[*].value,
  )...)
}
