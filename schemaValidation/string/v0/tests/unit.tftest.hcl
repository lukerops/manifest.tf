run "missing_value" {
  command = plan

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "string"
      version = "v0"
      subItem = null
      validations = {
        minLength = null
        maxLength = null
      }
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
      type    = "string"
      version = "v0"
      subItem = null
      validations = {
        minLength = null
        maxLength = null
      }
    }
    manifest = { test = 1 }
  }

  expect_failures = [
    output.resource,
  ]
}

run "with_wrong_minLegnth" {
  command = plan

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "string"
      version = "v0"
      subItem = null
      validations = {
        minLength = 10
        maxLength = null
      }
    }
    manifest = "test"
  }

  expect_failures = [
    output.resource,
  ]
}

run "with_wrong_maxLegnth" {
  command = plan

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "string"
      version = "v0"
      subItem = null
      validations = {
        minLength = null
        maxLength = 3
      }
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
      type    = "string"
      version = "v0"
      subItem = null
      validations = {
        minLength = 2
        maxLength = 5
      }
    }
    manifest = "test"
  }

  assert {
    condition     = output.resource == "test"
    error_message = "Error when validating string with minLength and maxLength."
  }
}
