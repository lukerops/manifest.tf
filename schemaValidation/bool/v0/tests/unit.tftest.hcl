run "missing_value" {
  command = plan

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type        = "bool"
      version     = "v0"
      subItem     = null
      validations = {}
    }
    manifest = null
  }

  expect_failures = [
    output.resource,
  ]
}

run "with_invalid_value" {
  command = plan

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type        = "bool"
      version     = "v0"
      subItem     = null
      validations = {}
    }
    manifest = "test"
  }

  expect_failures = [
    output.resource,
  ]
}

run "with_valid_value" {
  command = plan

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type        = "bool"
      version     = "v0"
      subItem     = null
      validations = {}
    }
    manifest = true
  }

  assert {
    condition     = output.resource
    error_message = "Error when validating basic manifest structure."
  }
}
