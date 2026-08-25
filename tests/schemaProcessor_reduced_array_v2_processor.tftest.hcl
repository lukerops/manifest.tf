run "without_items" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_array/v2/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type = "array"
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "without_default_value_and_with_bool_items" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_array/v2/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type = "array"
      items = {
        type = "bool"
      }
    }
  }

  assert {
    condition = output.schema == {
      type    = "reduced_array"
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
        has_default_value = false
        default_value     = null
      }
    }
    error_message = "Error when parsing reduced_array field without default value"
  }
}

run "with_default_value" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_array/v2/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type = "array"
      items = {
        type = "bool"
      }
      default = [true, false]
    }
  }

  assert {
    condition = output.schema == {
      type    = "reduced_array"
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
        default_value     = [true, false]
      }
    }
    error_message = "Error when parsing reduced_array field with default value"
  }
}

run "with_default_value_and_constraints" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_array/v2/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type     = "array"
      minItems = 1
      maxItems = 3
      items = {
        type = "integer"
      }
      default = [1, 2]
    }
  }

  assert {
    condition = output.schema == {
      type    = "reduced_array"
      version = "v2"
      subItem = {
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
      validations = {
        minItems          = 1
        maxItems          = 3
        has_default_value = true
        default_value     = [1, 2]
      }
    }
    error_message = "Error when parsing reduced_array field with default value and constraints"
  }
}

run "with_null_default_value" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_array/v2/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type = "array"
      items = {
        type = "bool"
      }
      default = null
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_default_value_incompatible_with_type_array" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_array/v2/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type = "array"
      items = {
        type = "bool"
      }
      default = "not-a-list"
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_invalid_minItems_and_maxItems" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_array/v2/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type     = "array"
      minItems = 10
      maxItems = 5
      items = {
        type = "bool"
      }
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_invalid_items_type" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_array/v2/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type = "array"
      items = {
        type = "object"
      }
    }
  }

  expect_failures = [
    output.schema,
  ]
}
