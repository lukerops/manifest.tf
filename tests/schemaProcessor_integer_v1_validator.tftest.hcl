run "without_field_value_without_default_value" {
  command = plan
  module {
    source = "./schemaProcessor/integer/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "integer"
      version = "v1"
      subItem = null
      validations = {
        minimum           = null
        maximum           = null
        default_value     = null
        has_default_value = false
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
    source = "./schemaProcessor/integer/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "integer"
      version = "v1"
      subItem = null
      validations = {
        minimum           = null
        maximum           = null
        default_value     = null
        has_default_value = false
      }
    }
    manifest = "not-a-number"
  }

  expect_failures = [
    output.resource,
  ]
}

run "with_invalid_value_with_default_value" {
  command = plan
  module {
    source = "./schemaProcessor/integer/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "integer"
      version = "v1"
      subItem = null
      validations = {
        minimum           = null
        maximum           = null
        default_value     = 10
        has_default_value = true
      }
    }
    manifest = "not-a-number"
  }

  expect_failures = [
    output.resource,
  ]
}

run "with_valid_value_without_default_value" {
  command = plan
  module {
    source = "./schemaProcessor/integer/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "integer"
      version = "v1"
      subItem = null
      validations = {
        minimum           = null
        maximum           = null
        default_value     = null
        has_default_value = false
      }
    }
    manifest = 42
  }

  assert {
    condition     = output.resource == 42
    error_message = "Error: did not fill the field with the valid provided value"
  }
}

run "with_valid_value_with_default_value" {
  command = plan
  module {
    source = "./schemaProcessor/integer/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "integer"
      version = "v1"
      subItem = null
      validations = {
        minimum           = null
        maximum           = null
        default_value     = 10
        has_default_value = true
      }
    }
    manifest = 42
  }

  assert {
    condition     = output.resource == 42
    error_message = "Error: replaced provided value with default value"
  }
}

run "without_field_value_with_default_value" {
  command = plan
  module {
    source = "./schemaProcessor/integer/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "integer"
      version = "v1"
      subItem = null
      validations = {
        minimum           = null
        maximum           = null
        default_value     = 10
        has_default_value = true
      }
    }
    manifest = null
  }

  assert {
    condition     = output.resource == 10
    error_message = "Error: did not use default value when field is absent"
  }
}

run "with_value_below_minimum" {
  command = plan
  module {
    source = "./schemaProcessor/integer/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "integer"
      version = "v1"
      subItem = null
      validations = {
        minimum           = 5
        maximum           = null
        default_value     = null
        has_default_value = false
      }
    }
    manifest = 2
  }

  expect_failures = [
    output.resource,
  ]
}

run "with_value_above_maximum" {
  command = plan
  module {
    source = "./schemaProcessor/integer/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema = {
      type    = "integer"
      version = "v1"
      subItem = null
      validations = {
        minimum           = null
        maximum           = 100
        default_value     = null
        has_default_value = false
      }
    }
    manifest = 200
  }

  expect_failures = [
    output.resource,
  ]
}
