run "without_field_value_without_default_value" {
  command = plan
  module {
    source = "./schemaProcessor/string/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
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
    manifest = null
  }

  expect_failures = [
    output.resource,
  ]
}

run "with_invalid_value" {
  command = plan
  module {
    source = "./schemaProcessor/string/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
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
    manifest = { invalid = "object" }
  }

  expect_failures = [
    output.resource,
  ]
}

run "with_valid_value_without_default_value" {
  command = plan
  module {
    source = "./schemaProcessor/string/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
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
    manifest = "hello"
  }

  assert {
    condition     = output.resource == "hello"
    error_message = "Error: did not return the provided value"
  }
}

run "without_field_value_with_default_value" {
  command = plan
  module {
    source = "./schemaProcessor/string/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "string"
      version = "v1"
      subItem = null
      validations = {
        minLength         = null
        maxLength         = null
        has_default_value = true
        default_value     = "default-value"
      }
    }
    manifest = null
  }

  assert {
    condition     = output.resource == "default-value"
    error_message = "Error: did not return the default value when field is absent"
  }
}

run "with_valid_value_overrides_default" {
  command = plan
  module {
    source = "./schemaProcessor/string/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "string"
      version = "v1"
      subItem = null
      validations = {
        minLength         = null
        maxLength         = null
        has_default_value = true
        default_value     = "default-value"
      }
    }
    manifest = "provided-value"
  }

  assert {
    condition     = output.resource == "provided-value"
    error_message = "Error: replaced provided value with default"
  }
}

run "with_minLength_violation" {
  command = plan
  module {
    source = "./schemaProcessor/string/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "string"
      version = "v1"
      subItem = null
      validations = {
        minLength         = 5
        maxLength         = null
        has_default_value = false
        default_value     = null
      }
    }
    manifest = "hi"
  }

  expect_failures = [
    output.resource,
  ]
}

run "with_maxLength_violation" {
  command = plan
  module {
    source = "./schemaProcessor/string/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "string"
      version = "v1"
      subItem = null
      validations = {
        minLength         = null
        maxLength         = 3
        has_default_value = false
        default_value     = null
      }
    }
    manifest = "toolong"
  }

  expect_failures = [
    output.resource,
  ]
}
