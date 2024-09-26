run "missing_value" {
  command = plan
  module {
    source = "./schemaValidation/integer/v0/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "integer"
      version = "v0"
      subItem = null
      validations = {
        minimum = null
        maximum = null
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
  module {
    source = "./schemaValidation/integer/v0/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "integer"
      version = "v0"
      subItem = null
      validations = {
        minimum = null
        maximum = null
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
  module {
    source = "./schemaValidation/integer/v0/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "integer"
      version = "v0"
      subItem = null
      validations = {
        minimum = 10
        maximum = null
      }
    }
    manifest = 5
  }

  expect_failures = [
    output.resource,
  ]
}

run "with_wrong_maxLegnth" {
  command = plan
  module {
    source = "./schemaValidation/integer/v0/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "integer"
      version = "v0"
      subItem = null
      validations = {
        minimum = null
        maximum = 3
      }
    }
    manifest = 5
  }

  expect_failures = [
    output.resource,
  ]
}


run "with_valid_value" {
  command = plan
  module {
    source = "./schemaValidation/integer/v0/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "integer"
      version = "v0"
      subItem = null
      validations = {
        minimum = 2
        maximum = 5
      }
    }
    manifest = 5
  }

  assert {
    condition     = output.resource == 5
    error_message = "Error when validating integer with minimum and maximum."
  }
}
