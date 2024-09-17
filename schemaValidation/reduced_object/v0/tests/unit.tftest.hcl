run "missing_value" {
  command = plan

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type        = "reduced_object"
      version     = "v0"
      validations = {}
      subItem = {
        stringProperty = {
          type    = "string"
          version = "v0"
          subItem = null
          validations = {
            minLength = null
            maxLength = null
          }
        }
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
      type        = "reduced_object"
      version     = "v0"
      validations = {}
      subItem = {
        stringProperty = {
          type    = "string"
          version = "v0"
          subItem = null
          validations = {
            minLength = null
            maxLength = null
          }
        }
      }
    }
    manifest = [1]
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
      type        = "reduced_object"
      version     = "v0"
      validations = {}
      subItem = {
        stringProperty = {
          type    = "string"
          version = "v0"
          subItem = null
          validations = {
            minLength = 1
            maxLength = null
          }
        }
        integerProperty = {
          type    = "integer"
          version = "v0"
          subItem = null
          validations = {
            minimum = 1
            maximum = null
          }
        }
        boolProperty = {
          type        = "bool"
          version     = "v0"
          subItem     = null
          validations = {}
        }
      }
    }
    manifest = {
      stringProperty  = "test"
      integerProperty = 1
      boolProperty    = true
    }
  }

  assert {
    condition = output.resource == {
      stringProperty  = "test"
      integerProperty = 1
      boolProperty    = true
    }
    error_message = "Error when validating reduced_object."
  }
}
