run "missing_value" {
  command = plan
  module {
    source = "./schemaValidation/reduced_array/v0/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "reduced_array"
      version = "v0"
      subItem = {
        type    = "string"
        version = "v0"
        subItem = null
        validations = {
          minLength = null
          maxLength = null
        }
      }
      validations = {
        minItems = null
        maxItems = null
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
    source = "./schemaValidation/reduced_array/v0/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "reduced_array"
      version = "v0"
      subItem = {
        type    = "string"
        version = "v0"
        subItem = null
        validations = {
          minLength = null
          maxLength = null
        }
      }
      validations = {
        minItems = null
        maxItems = null
      }
    }
    manifest = { test = 1 }
  }

  expect_failures = [
    output.resource,
  ]
}

run "with_wrong_minItems" {
  command = plan
  module {
    source = "./schemaValidation/reduced_array/v0/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "reduced_array"
      version = "v0"
      subItem = {
        type    = "string"
        version = "v0"
        subItem = null
        validations = {
          minLength = null
          maxLength = null
        }
      }
      validations = {
        minItems = 3
        maxItems = null
      }
    }
    manifest = ["test1"]
  }

  expect_failures = [
    output.resource,
  ]
}

run "with_wrong_maxItems" {
  command = plan
  module {
    source = "./schemaValidation/reduced_array/v0/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "reduced_array"
      version = "v0"
      subItem = {
        type    = "string"
        version = "v0"
        subItem = null
        validations = {
          minLength = null
          maxLength = null
        }
      }
      validations = {
        minItems = 1
        maxItems = 2
      }
    }
    manifest = ["test1", "test2", "test3"]
  }

  expect_failures = [
    output.resource,
  ]
}

run "with_valid_value" {
  command = plan
  module {
    source = "./schemaValidation/reduced_array/v0/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "reduced_array"
      version = "v0"
      subItem = {
        type    = "integer"
        version = "v0"
        subItem = null
        validations = {
          minimum = 1
          maximum = 5
        }
      }
      validations = {
        minItems = 1
        maxItems = 2
      }
    }
    manifest = [3, 4]
  }

  assert {
    condition     = output.resource == [3, 4]
    error_message = "Error when validating reduced_array with minItems and maxItems."
  }
}
