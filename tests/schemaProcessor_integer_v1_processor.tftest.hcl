run "without_default_value" {
  command = plan
  module {
    source = "./schemaProcessor/integer/v1/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type = "integer"
    }
  }

  assert {
    condition = output.schema == {
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
    error_message = "Error when parsing integer field without default value"
  }
}

run "with_default_value" {
  command = plan
  module {
    source = "./schemaProcessor/integer/v1/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type    = "integer"
      default = 42
    }
  }

  assert {
    condition = output.schema == {
      type    = "integer"
      version = "v1"
      subItem = null
      validations = {
        minimum           = null
        maximum           = null
        has_default_value = true
        default_value     = 42
      }
    }
    error_message = "Error when parsing integer field with default value"
  }
}

run "with_default_value_and_constraints" {
  command = plan
  module {
    source = "./schemaProcessor/integer/v1/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type    = "integer"
      minimum = 1
      maximum = 100
      default = 10
    }
  }

  assert {
    condition = output.schema == {
      type    = "integer"
      version = "v1"
      subItem = null
      validations = {
        minimum           = 1
        maximum           = 100
        has_default_value = true
        default_value     = 10
      }
    }
    error_message = "Error when parsing integer field with default value and constraints"
  }
}

run "with_null_default_value" {
  command = plan
  module {
    source = "./schemaProcessor/integer/v1/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type    = "integer"
      default = null
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_default_value_incompatible_with_type_integer" {
  command = plan
  module {
    source = "./schemaProcessor/integer/v1/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type    = "integer"
      default = "not-a-number"
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_invalid_minimum" {
  command = plan
  module {
    source = "./schemaProcessor/integer/v1/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type    = "integer"
      minimum = "invalid"
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_invalid_maximum" {
  command = plan
  module {
    source = "./schemaProcessor/integer/v1/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type    = "integer"
      maximum = "invalid"
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_invalid_minimum_and_maximum" {
  command = plan
  module {
    source = "./schemaProcessor/integer/v1/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type    = "integer"
      minimum = 10
      maximum = 5
    }
  }

  expect_failures = [
    output.schema,
  ]
}
