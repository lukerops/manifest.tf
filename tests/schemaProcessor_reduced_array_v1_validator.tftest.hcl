run "without_field_value_without_default_value" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_array/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
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
    manifest = null
  }

  expect_failures = [
    output.resource,
  ]
}

run "with_invalid_value" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_array/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
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
    manifest = { test = 1 }
  }

  expect_failures = [
    output.resource,
  ]
}

run "with_invalid_value_with_default_value" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_array/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
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
        default_value     = ["a"]
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
    source = "./schemaProcessor/reduced_array/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
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
        minItems          = 3
        maxItems          = null
        has_default_value = false
        default_value     = null
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
    source = "./schemaProcessor/reduced_array/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
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
        minItems          = 1
        maxItems          = 2
        has_default_value = false
        default_value     = null
      }
    }
    manifest = ["test1", "test2", "test3"]
  }

  expect_failures = [
    output.resource,
  ]
}

run "with_valid_value_without_default_value" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_array/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "reduced_array"
      version = "v1"
      subItem = {
        type    = "integer"
        version = "v1"
        subItem = null
        validations = {
          minimum           = 1
          maximum           = 5
          has_default_value = false
          default_value     = null
        }
      }
      validations = {
        minItems          = 1
        maxItems          = 2
        has_default_value = false
        default_value     = null
      }
    }
    manifest = [3, 4]
  }

  assert {
    condition     = output.resource == [3, 4]
    error_message = "Error: did not fill the field with the valid provided value"
  }
}

run "with_valid_value_with_default_value" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_array/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "reduced_array"
      version = "v1"
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
    manifest = [false, true]
  }

  assert {
    condition     = output.resource == [false, true]
    error_message = "Error: replaced provided value with default value"
  }
}

run "without_field_value_with_default_value" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_array/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "reduced_array"
      version = "v1"
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
        default_value     = [true, false]
      }
    }
    manifest = null
  }

  assert {
    condition     = output.resource == [true, false]
    error_message = "Error: did not use default value when field is absent"
  }
}
