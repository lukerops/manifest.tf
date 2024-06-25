run "without_properties" {
  command = plan

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type = "object"
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_invalid_properties" {
  command = plan

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type       = "object"
      properties = "invalid"
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_properties_missing_type" {
  command = plan

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type = "object"
      properties = {
        test = {}
      }
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_properties_invalid_type" {
  command = plan

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type = "object"
      properties = {
        test = {
          type = "invalid"
        }
      }
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_properties" {
  command = plan

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type = "object"
      properties = {
        boolProperty = {
          type = "bool"
        }
        stringProperty = {
          type      = "string"
          minLength = 1
        }
        integerProperty = {
          type    = "integer"
          minimum = 1
        }
        arrayProperty = {
          type = "array"
          items = {
            type      = "string"
            minLength = 1
          }
        }
        objectProperty = {
          type = "object"
          properties = {
            stringProperty = {
              type      = "string"
              minLength = 1
            }
          }
        }
      }
    }
  }

  assert {
    condition = output.schema == {
      type        = "root_object"
      version     = "v0"
      validations = {}
      subItem = {
        boolProperty = {
          type        = "bool"
          version     = "v0"
          subItem     = null
          validations = {}
        }
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
        arrayProperty = {
          type    = "array"
          version = "v0"
          subItem = {
            type    = "string"
            version = "v0"
            subItem = null
            validations = {
              minLength = 1
              maxLength = null
            }
          }
          validations = {
            minItems = null
            maxItems = null
          }
        }
        objectProperty = {
          type        = "object"
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
          }
        }
      }
    }
    error_message = "Error when parsing root_object with properties."
  }
}
