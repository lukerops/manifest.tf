run "required_field_with_value" {
  command = plan
  module {
    source = "./schemaProcessor/integer/v1/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.replicas"
    manifest = {
      type = "integer"
    }
  }
}

run "required_field_with_value_validate" {
  command = plan
  module {
    source = "./schemaProcessor/integer/v1/validator"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.replicas"
    schema        = run.required_field_with_value.schema
    manifest      = 3
  }

  assert {
    condition     = output.resource == 3
    error_message = "Error: provided value was not returned as-is"
  }
}

run "required_field_missing" {
  command = plan
  module {
    source = "./schemaProcessor/integer/v1/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.replicas"
    manifest = {
      type = "integer"
    }
  }
}

run "required_field_missing_validate" {
  command = plan
  module {
    source = "./schemaProcessor/integer/v1/validator"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.replicas"
    schema        = run.required_field_missing.schema
    manifest      = null
  }

  expect_failures = [
    output.resource,
  ]
}

run "optional_field_missing_uses_default" {
  command = plan
  module {
    source = "./schemaProcessor/integer/v1/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.replicas"
    manifest = {
      type    = "integer"
      default = 1
    }
  }
}

run "optional_field_missing_uses_default_validate" {
  command = plan
  module {
    source = "./schemaProcessor/integer/v1/validator"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.replicas"
    schema        = run.optional_field_missing_uses_default.schema
    manifest      = null
  }

  assert {
    condition     = output.resource == 1
    error_message = "Error: default value was not used when field is absent"
  }
}

run "optional_field_overrides_default" {
  command = plan
  module {
    source = "./schemaProcessor/integer/v1/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.replicas"
    manifest = {
      type    = "integer"
      default = 1
    }
  }
}

run "optional_field_overrides_default_validate" {
  command = plan
  module {
    source = "./schemaProcessor/integer/v1/validator"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.replicas"
    schema        = run.optional_field_overrides_default.schema
    manifest      = 5
  }

  assert {
    condition     = output.resource == 5
    error_message = "Error: provided value was replaced by default value"
  }
}

run "invalid_value_does_not_fall_back_to_default" {
  command = plan
  module {
    source = "./schemaProcessor/integer/v1/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.replicas"
    manifest = {
      type    = "integer"
      default = 1
    }
  }
}

run "invalid_value_does_not_fall_back_to_default_validate" {
  command = plan
  module {
    source = "./schemaProcessor/integer/v1/validator"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.replicas"
    schema        = run.invalid_value_does_not_fall_back_to_default.schema
    manifest      = "not-a-number"
  }

  expect_failures = [
    output.resource,
  ]
}
