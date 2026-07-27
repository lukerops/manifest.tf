run "without_properties" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_object/v1/processor"
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
    source = "./schemaProcessor/reduced_object/v1/processor"
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
    source = "./schemaProcessor/reduced_object/v1/processor"
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
    source = "./schemaProcessor/reduced_object/v1/processor"
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
    source = "./schemaProcessor/reduced_object/v1/processor"
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
          type = "string"
        }
        integerProperty = {
          type = "integer"
        }
        arrayProperty = {
          type = "array"
          items = {
            type = "string"
          }
        }
      }
    }
  }

  assert {
    condition = output.schema == {
      type        = "reduced_object"
      version     = "v1"
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
            minLength         = null
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
            minimum           = null
            maximum           = null
            has_default_value = false
            default_value     = null
          }
        }
        arrayProperty = {
          type    = "reduced_array"
          version = "v1"
          subItem = {
            type    = "string"
            version = "v1"
            subItem = null
            validations = {
              minLength         = null
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
      }
    }
    error_message = "Error when parsing reduced_object with properties without default values."
  }
}

run "with_properties_with_default_values" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_object/v1/processor"
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
      }
    }
  }

  assert {
    condition = output.schema == {
      type        = "reduced_object"
      version     = "v1"
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
      }
    }
    error_message = "Error when parsing reduced_object with properties with default values."
  }
}
