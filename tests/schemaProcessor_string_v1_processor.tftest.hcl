run "without_default_value" {
  command = plan
  module {
    source = "./schemaProcessor/string/v1/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type = "string"
    }
  }

  assert {
    condition = output.schema == {
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
    error_message = "Error when parsing string field without default value"
  }
}

run "with_default_value" {
  command = plan
  module {
    source = "./schemaProcessor/string/v1/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type    = "string"
      default = "hello"
    }
  }

  assert {
    condition = output.schema == {
      type    = "string"
      version = "v1"
      subItem = null
      validations = {
        minLength         = null
        maxLength         = null
        has_default_value = true
        default_value     = "hello"
      }
    }
    error_message = "Error when parsing string field with default value"
  }
}

run "with_default_value_and_constraints" {
  command = plan
  module {
    source = "./schemaProcessor/string/v1/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type      = "string"
      minLength = 1
      maxLength = 10
      default   = "hello"
    }
  }

  assert {
    condition = output.schema == {
      type    = "string"
      version = "v1"
      subItem = null
      validations = {
        minLength         = 1
        maxLength         = 10
        has_default_value = true
        default_value     = "hello"
      }
    }
    error_message = "Error when parsing string field with default value and constraints"
  }
}

run "with_null_default_value" {
  command = plan
  module {
    source = "./schemaProcessor/string/v1/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type    = "string"
      default = null
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_invalid_minLength" {
  command = plan
  module {
    source = "./schemaProcessor/string/v1/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type      = "string"
      minLength = "invalid"
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_invalid_maxLength" {
  command = plan
  module {
    source = "./schemaProcessor/string/v1/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type      = "string"
      maxLength = "invalid"
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_invalid_minLength_and_maxLength" {
  command = plan
  module {
    source = "./schemaProcessor/string/v1/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.versions[0].specSchema.test"
    manifest = {
      type      = "string"
      minLength = 10
      maxLength = 5
    }
  }

  expect_failures = [
    output.schema,
  ]
}
