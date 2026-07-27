run "missing_value" {
  command = plan
  module {
    source = "./schemaProcessor/object/v2/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type        = "object"
      version     = "v2"
      validations = {}
      subItem = {
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
    source = "./schemaProcessor/object/v2/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type        = "object"
      version     = "v2"
      validations = {}
      subItem = {
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
      }
    }
    manifest = [1]
  }

  expect_failures = [
    output.resource,
  ]
}

run "with_missing_required_property" {
  command = plan
  module {
    source = "./schemaProcessor/object/v2/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type        = "object"
      version     = "v2"
      validations = {}
      subItem = {
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
      }
    }
    manifest = {}
  }

  expect_failures = [
    output.resource,
  ]
}

run "with_valid_value" {
  command = plan
  module {
    source = "./schemaProcessor/object/v2/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type        = "object"
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
        boolProperty = {
          type    = "bool"
          version = "v1"
          subItem = null
          validations = {
            has_default_value = false
            default_value     = null
          }
        }
        reducedObjectProperty = {
          type    = "reduced_object"
          version = "v2"
          validations = {
            optional = false
          }
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
    manifest = {
      stringProperty  = "test"
      integerProperty = 1
      boolProperty    = true
      reducedObjectProperty = {
        stringProperty = "test"
      }
    }
  }

  assert {
    condition = output.resource == {
      stringProperty  = "test"
      integerProperty = 1
      boolProperty    = true
      reducedObjectProperty = {
        stringProperty = "test"
      }
    }
    error_message = "Error when validating object."
  }
}

run "with_missing_bool_property_uses_default" {
  command = plan
  module {
    source = "./schemaProcessor/object/v2/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type        = "object"
      version     = "v2"
      validations = {}
      subItem = {
        active = {
          type    = "bool"
          version = "v1"
          subItem = null
          validations = {
            has_default_value = true
            default_value     = true
          }
        }
      }
    }
    manifest = {}
  }

  assert {
    condition     = output.resource == { active = true }
    error_message = "Error: did not use default value for missing bool property"
  }
}

run "with_missing_string_property_uses_default" {
  command = plan
  module {
    source = "./schemaProcessor/object/v2/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type        = "object"
      version     = "v2"
      validations = {}
      subItem = {
        name = {
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
      }
    }
    manifest = {}
  }

  assert {
    condition     = output.resource == { name = "fallback" }
    error_message = "Error: did not use default value for missing string property"
  }
}

run "with_missing_array_property_uses_default" {
  command = plan
  module {
    source = "./schemaProcessor/object/v2/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type        = "object"
      version     = "v2"
      validations = {}
      subItem = {
        tags = {
          type    = "array"
          version = "v2"
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
            has_default_value = true
            default_value     = ["default-tag"]
          }
        }
      }
    }
    manifest = {}
  }

  assert {
    condition     = output.resource == { tags = ["default-tag"] }
    error_message = "Error: did not use default value for missing array property"
  }
}
