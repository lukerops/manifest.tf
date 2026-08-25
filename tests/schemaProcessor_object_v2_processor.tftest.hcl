run "without_properties" {
  command = plan
  module {
    source = "./schemaProcessor/object/v2/processor"
  }

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
  module {
    source = "./schemaProcessor/object/v2/processor"
  }

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
  module {
    source = "./schemaProcessor/object/v2/processor"
  }

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
  module {
    source = "./schemaProcessor/object/v2/processor"
  }

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

run "with_properties_without_default_values" {
  command = plan
  module {
    source = "./schemaProcessor/object/v2/processor"
  }

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
      type        = "object"
      version     = "v2"
      validations = {}
      subItem = {
        boolProperty = {
          type    = "bool"
          version = "v1"
          subItem = null
          validations = {
            has_default_value = false
            default_value     = null
          }
        }
        stringProperty = {
          type    = "string"
          version = "v1"
          subItem = null
          validations = {
            minLength         = 1
            maxLength         = null
            has_default_value = false
            default_value     = null
          }
        }
        integerProperty = {
          type    = "integer"
          version = "v1"
          subItem = null
          validations = {
            minimum           = 1
            maximum           = null
            has_default_value = false
            default_value     = null
          }
        }
        arrayProperty = {
          type    = "array"
          version = "v2"
          subItem = {
            type    = "string"
            version = "v1"
            subItem = null
            validations = {
              minLength         = 1
              maxLength         = null
              has_default_value = false
              default_value     = null
            }
          }
          validations = {
            minItems          = null
            maxItems          = null
            has_default_value = false
            default_value     = null
          }
        }
        objectProperty = {
          type        = "reduced_object"
          version     = "v2"
          validations = {}
          subItem = {
            stringProperty = {
              type    = "string"
              version = "v1"
              subItem = null
              validations = {
                minLength         = 1
                maxLength         = null
                has_default_value = false
                default_value     = null
              }
            }
          }
        }
      }
    }
    error_message = "Error when parsing object with properties without default values."
  }
}

run "with_properties_with_default_values" {
  command = plan
  module {
    source = "./schemaProcessor/object/v2/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type = "object"
      properties = {
        boolProperty = {
          type    = "bool"
          default = true
        }
        stringProperty = {
          type    = "string"
          default = "fallback"
        }
        integerProperty = {
          type    = "integer"
          default = 1
        }
        arrayProperty = {
          type = "array"
          items = {
            type = "bool"
          }
          default = [true]
        }
      }
    }
  }

  assert {
    condition = output.schema == {
      type        = "object"
      version     = "v2"
      validations = {}
      subItem = {
        boolProperty = {
          type    = "bool"
          version = "v1"
          subItem = null
          validations = {
            has_default_value = true
            default_value     = true
          }
        }
        stringProperty = {
          type    = "string"
          version = "v1"
          subItem = null
          validations = {
            minLength         = null
            maxLength         = null
            has_default_value = true
            default_value     = "fallback"
          }
        }
        integerProperty = {
          type    = "integer"
          version = "v1"
          subItem = null
          validations = {
            minimum           = null
            maximum           = null
            has_default_value = true
            default_value     = 1
          }
        }
        arrayProperty = {
          type    = "array"
          version = "v2"
          subItem = {
            type    = "bool"
            version = "v1"
            subItem = null
            validations = {
              has_default_value = false
              default_value     = null
            }
          }
          validations = {
            minItems          = null
            maxItems          = null
            has_default_value = true
            default_value     = [true]
          }
        }
      }
    }
    error_message = "Error when parsing object with properties with default values."
  }
}
