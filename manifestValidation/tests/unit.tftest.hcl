run "with_invalid_yaml" {
  command = plan

  variables {
    path = "."
    text = "teste"
  }

  expect_failures = [
    output.manifest,
  ]
}

run "missing_apiVersion" {
  command = plan

  variables {
    path = "."
    text = "{}"
  }

  expect_failures = [
    output.manifest,
  ]
}

run "invalid_apiVersion" {
  command = plan

  variables {
    path = "."
    text = <<-EOT
        "apiVersion": "test.group"
    EOT
  }

  expect_failures = [
    output.manifest,
  ]
}

run "missing_kind" {
  command = plan

  variables {
    path = "."
    text = <<-EOT
        "apiVersion": "test.group/v1alpha1"
    EOT
  }

  expect_failures = [
    output.manifest,
  ]
}

run "missing_metadata" {
  command = plan

  variables {
    path = "."
    text = <<-EOT
        "apiVersion": "test.group/v1alpha1"
        "kind": "Test"
    EOT
  }

  expect_failures = [
    output.manifest,
  ]
}

run "missing_metadata_name" {
  command = plan

  variables {
    path = "."
    text = <<-EOT
        "apiVersion": "test.group/v1alpha1"
        "kind": "Test"
        "metadata": {}
    EOT
  }

  expect_failures = [
    output.manifest,
  ]
}

run "missing_spec" {
  command = plan

  variables {
    path = "."
    text = <<-EOT
        "apiVersion": "test.group/v1alpha1"
        "kind": "Test"
        "metadata":
          "name": "test"
    EOT
  }

  expect_failures = [
    output.manifest,
  ]
}

run "with_valid_manifest" {
  command = plan

  variables {
    path = "."
    text = <<-EOT
        "apiVersion": "test.group/v1alpha1"
        "kind": "Test"
        "metadata":
          "name": "test"
        "spec":
          "test": "test"
    EOT
  }

  assert {
    condition = output.manifest == {
      apiVersion = "test.group/v1alpha1",
      kind       = "Test",
      metadata = {
        name = "test",
      },
      spec = {
        test = "test",
      }
    }
    error_message = "Error when validating basic manifest structure."
  }
}
