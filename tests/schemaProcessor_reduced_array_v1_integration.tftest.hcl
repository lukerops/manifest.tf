run "required_field_with_value" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_array/v1/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    manifest = {
      type = "array"
      items = {
        type = "bool"
      }
    }
  }
}

run "required_field_manifest_provides_value" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_array/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema        = run.required_field_with_value.schema
    manifest      = [true, false]
  }

  assert {
    condition     = output.resource == [true, false]
    error_message = "Error: did not return the provided value for a required field"
  }
}

run "required_field_manifest_missing_value" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_array/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema        = run.required_field_with_value.schema
    manifest      = null
  }

  expect_failures = [
    output.resource,
  ]
}

run "optional_field_with_default" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_array/v1/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    manifest = {
      type = "array"
      items = {
        type = "bool"
      }
      default = [true]
    }
  }
}

run "optional_field_manifest_missing_uses_default" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_array/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema        = run.optional_field_with_default.schema
    manifest      = null
  }

  assert {
    condition     = output.resource == [true]
    error_message = "Error: did not use default value when field is absent"
  }
}

run "optional_field_manifest_overrides_default" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_array/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema        = run.optional_field_with_default.schema
    manifest      = [false, false]
  }

  assert {
    condition     = output.resource == [false, false]
    error_message = "Error: replaced provided value with default"
  }
}

run "optional_field_invalid_value_does_not_fall_back_to_default" {
  command = plan
  module {
    source = "./schemaProcessor/reduced_array/v1/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema        = run.optional_field_with_default.schema
    manifest      = { invalid = "object" }
  }

  expect_failures = [
    output.resource,
  ]
}
