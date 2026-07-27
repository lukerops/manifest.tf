run "required_property_with_value" {
  command = plan
  module {
    source = "./schemaProcessor/root_object/v2/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    manifest = {
      type = "object"
      properties = {
        name = {
          type = "string"
        }
      }
    }
  }
}

run "required_property_manifest_provides_value" {
  command = plan
  module {
    source = "./schemaProcessor/root_object/v2/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema        = run.required_property_with_value.schema
    manifest = {
      name = "hello"
    }
  }

  assert {
    condition     = output.resource == { name = "hello" }
    error_message = "Error: did not return the provided value for a required property"
  }
}

run "required_property_manifest_missing_value" {
  command = plan
  module {
    source = "./schemaProcessor/root_object/v2/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema        = run.required_property_with_value.schema
    manifest      = {}
  }

  expect_failures = [
    output.resource,
  ]
}

run "optional_property_with_default" {
  command = plan
  module {
    source = "./schemaProcessor/root_object/v2/processor"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    manifest = {
      type = "object"
      properties = {
        name = {
          type    = "string"
          default = "fallback"
        }
      }
    }
  }
}

run "optional_property_manifest_missing_uses_default" {
  command = plan
  module {
    source = "./schemaProcessor/root_object/v2/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema        = run.optional_property_with_default.schema
    manifest      = {}
  }

  assert {
    condition     = output.resource == { name = "fallback" }
    error_message = "Error: did not use default value when property is absent"
  }
}

run "optional_property_manifest_overrides_default" {
  command = plan
  module {
    source = "./schemaProcessor/root_object/v2/validator/"
  }

  variables {
    metadata_name = "test"
    path          = "."
    field_path    = "spec.test"
    schema        = run.optional_property_with_default.schema
    manifest = {
      name = "provided"
    }
  }

  assert {
    condition     = output.resource == { name = "provided" }
    error_message = "Error: replaced provided value with default"
  }
}
