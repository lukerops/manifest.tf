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
    text = yamlencode({})
  }

  expect_failures = [
    output.manifest,
  ]
}

run "invalid_apiVersion" {
  command = plan

  variables {
    path = "."
    text = yamlencode({
      apiVersion = "test.group",
    })
  }

  expect_failures = [
    output.manifest,
  ]
}

run "missing_kind" {
  command = plan

  variables {
    path = "."
    text = yamlencode({
      apiVersion = "test.group/v1alpha1",
    })
  }

  expect_failures = [
    output.manifest,
  ]
}

run "missing_metadata" {
  command = plan

  variables {
    path = "."
    text = yamlencode({
      apiVersion = "test.group/v1alpha1",
      kind       = "Test",
    })
  }

  expect_failures = [
    output.manifest,
  ]
}

run "missing_metadata_name" {
  command = plan

  variables {
    path = "."
    text = yamlencode({
      apiVersion = "test.group/v1alpha1",
      kind       = "Test",
      metadata   = {},
    })
  }

  expect_failures = [
    output.manifest,
  ]
}

run "missing_spec" {
  command = plan

  variables {
    path = "."
    text = yamlencode({
      apiVersion = "test.group/v1alpha1",
      kind       = "Test",
      metadata = {
        name = "test",
      },
    })
  }

  expect_failures = [
    output.manifest,
  ]
}

run "with_valid_manifest" {
  command = plan

  variables {
    path = "."
    text = yamlencode({
      apiVersion = "test.group/v1alpha1",
      kind       = "Test",
      metadata = {
        name = "test",
      },
      spec = {
        test = "test",
      }
    })
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
