run "missing_value" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_object/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type        = "reduced_object"
      version     = "v1"
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
    source = "./schemaProcessor/reduced_object/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type        = "reduced_object"
      version     = "v1"
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
    source = "./schemaProcessor/reduced_object/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type        = "reduced_object"
      version     = "v1"
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
    source = "./schemaProcessor/reduced_object/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type        = "reduced_object"
      version     = "v1"
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

run "with_missing_bool_property_uses_default" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_object/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type        = "reduced_object"
      version     = "v1"
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

run "with_null_bool_property_uses_default" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_object/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type        = "reduced_object"
      version     = "v1"
      validations = {}
      subItem = {
        active = {
          type    = "bool"
          version = "v1"
          subItem = null
          validations = {
            has_default_value = true
            default_value     = false
          }
        }
      }
    }
    manifest = {
      active = null
    }
  }

  assert {
    condition     = output.resource == { active = false }
    error_message = "Error: did not use default value for null bool property"
  }
}

run "with_missing_string_property_uses_default" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_object/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type        = "reduced_object"
      version     = "v1"
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

run "with_missing_integer_property_uses_default" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_object/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type        = "reduced_object"
      version     = "v1"
      validations = {}
      subItem = {
        replicas = {
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
    manifest = {}
  }

  assert {
    condition     = output.resource == { replicas = 1 }
    error_message = "Error: did not use default value for missing integer property"
  }
}

run "with_missing_reduced_array_property_uses_default" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_object/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type        = "reduced_object"
      version     = "v1"
      validations = {}
      subItem = {
        tags = {
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
    error_message = "Error: did not use default value for missing reduced_array property"
  }
}
