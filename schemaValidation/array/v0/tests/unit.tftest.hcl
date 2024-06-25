run "missing_value" {
  command = plan

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "array"
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

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "array"
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

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "array"
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

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "array"
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

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "array"
      version = "v0"
      subItem = {
        type        = "reduced_object"
        version     = "v0"
        validations = {}
        subItem = {
          integerProperty = {
            type    = "integer"
            version = "v0"
            subItem = null
            validations = {
              minimum = 1
              maximum = null
            }
          }
        }
      }
      validations = {
        minItems = 1
        maxItems = 2
      }
    }
    manifest = [{
      integerProperty = 3
    }]
  }

  assert {
    condition     = output.resource == [{ integerProperty = 3 }]
    error_message = "Error when validating array with minItems and maxItems."
  }
}
