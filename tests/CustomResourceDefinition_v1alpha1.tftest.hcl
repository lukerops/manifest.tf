run "missing_group" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha1/"
  }

  variables {
    path = "."
    manifest = {
      metadata = {
        name = "test"
      }
      spec = {}
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "missing_kind" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha1/"
  }

  variables {
    path = "."
    manifest = {
      metadata = {
        name = "test"
      }
      spec = {
        group = "test.group"
      }
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "missing_versions" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha1/"
  }

  variables {
    path = "."
    manifest = {
      metadata = {
        name = "test"
      }
      spec = {
        group = "test.group"
        kind  = "Test"
      }
    }
  }

  expect_failures = [
    output.schema,
  ]
}

run "with_invalid_versions" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha1/"
  }

  variables {
    path = "."
    manifest = {
      metadata = {
        name = "test"
      }
      spec = {
        group    = "test.group"
        kind     = "Test"
        versions = 123
      }
    }
  }

  expect_failures = [
    output.schema,
  ]
}


run "with_valid_versions" {
  command = plan
  module {
    source = "./CustomResourceDefinition/v1alpha1/"
  }

  variables {
    path = "."
    manifest = {
      metadata = {
        name = "test"
      }
      spec = {
        group = "test.group"
        kind  = "Test"
        versions = [{
          name = "v1alpha1"
          specSchema = {
            type = "object"
            properties = {
              test = {
                type      = "string"
                minLength = 1
              }
            }
          }
        }]
      }
    }
  }

  assert {
    condition = output.schema == {
      path  = "."
      name  = "test"
      group = "test.group"
      kind  = "Test"
      versions = {
        v1alpha1 = {
          name       = "v1alpha1"
          enabled    = true
          deprecated = false
          schema = {
            type        = "root_object"
            version     = "v0"
            validations = {}
            subItem = {
              test = {
                type    = "string"
                version = "v0"
                subItem = null
                validations = {
                  minLength = 1
                  maxLength = null
                }
              }
            }
          }
        }
      }
    }
    error_message = "Error when parsing manifest with valid version."
  }
}
