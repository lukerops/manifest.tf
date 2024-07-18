run "duplicated_custom_resource_definition" {
  command = plan

  variables {
    path = "."
    custom_resource_definitions = [
      {
        path  = "."
        name  = "test.testGroup"
        group = "testGroup"
        kind  = "Test"
        versions = {
          "v1alpha1" = {
            name       = "v1alpha1"
            enabled    = true
            deprecated = false
            schema = {
              type        = "object"
              version     = "v0"
              validations = {}
              subItem = {
                stringProperty = {
                  type    = "string"
                  version = "v0"
                  subItem = null
                  validations = {
                    minLength = null
                    maxLength = null
                  }
                }
              }
            }
          }
        }
      },
      {
        path  = "."
        name  = "test.testGroup"
        group = "testGroup"
        kind  = "Test"
        versions = {
          "v1alpha1" = {
            name       = "v1alpha1"
            enabled    = true
            deprecated = false
            schema = {
              type        = "object"
              version     = "v0"
              validations = {}
              subItem = {
                stringProperty = {
                  type    = "string"
                  version = "v0"
                  subItem = null
                  validations = {
                    minLength = null
                    maxLength = null
                  }
                }
              }
            }
          }
        }
      }
    ]
    manifest = {
      apiVersion = "testGroup/v1alpha1"
      kind       = "Test"
      metadata = {
        name = "test"
      }
      spec = {
        stringProperty = "test"
      }
    }
  }

  expect_failures = [
    output.instance,
  ]
}

run "custom_resource_definition_not_found" {
  command = plan

  variables {
    path = "."
    custom_resource_definitions = [
      {
        path  = "."
        name  = "test.testGroup"
        group = "testGroup"
        kind  = "Test"
        versions = {
          "v1alpha1" = {
            name       = "v1alpha1"
            enabled    = true
            deprecated = false
            schema = {
              type        = "object"
              version     = "v0"
              validations = {}
              subItem = {
                stringProperty = {
                  type    = "string"
                  version = "v0"
                  subItem = null
                  validations = {
                    minLength = null
                    maxLength = null
                  }
                }
              }
            }
          }
        }
      },
    ]
    manifest = {
      apiVersion = "testGroup/v1alpha2"
      kind       = "Test"
      metadata = {
        name = "test"
      }
      spec = {
        stringProperty = "test"
      }
    }
  }

  expect_failures = [
    output.instance,
  ]
}

run "kind_not_found" {
  command = plan

  variables {
    path = "."
    custom_resource_definitions = [
      {
        path  = "."
        name  = "test.testGroup"
        group = "testGroup"
        kind  = "Test"
        versions = {
          "v1alpha1" = {
            name       = "v1alpha1"
            enabled    = true
            deprecated = false
            schema = {
              type        = "object"
              version     = "v0"
              validations = {}
              subItem = {
                stringProperty = {
                  type    = "string"
                  version = "v0"
                  subItem = null
                  validations = {
                    minLength = null
                    maxLength = null
                  }
                }
              }
            }
          }
        }
      },
    ]
    manifest = {
      apiVersion = "testGroup/v1alpha1"
      kind       = "MissingTest"
      metadata = {
        name = "test"
      }
      spec = {
        stringProperty = "test"
      }
    }
  }

  expect_failures = [
    output.instance,
  ]
}

run "disabled_version" {
  command = plan

  variables {
    path = "."
    custom_resource_definitions = [
      {
        path  = "."
        name  = "test.testGroup"
        group = "testGroup"
        kind  = "Test"
        versions = {
          "v1alpha1" = {
            name       = "v1alpha1"
            enabled    = false
            deprecated = false
            schema = {
              type        = "object"
              version     = "v0"
              validations = {}
              subItem = {
                stringProperty = {
                  type    = "string"
                  version = "v0"
                  subItem = null
                  validations = {
                    minLength = null
                    maxLength = null
                  }
                }
              }
            }
          }
        }
      },
    ]
    manifest = {
      apiVersion = "testGroup/v1alpha1"
      kind       = "Test"
      metadata = {
        name = "test"
      }
      spec = {
        stringProperty = "test"
      }
    }
  }

  expect_failures = [
    output.instance,
  ]
}

run "deprecated_version" {
  command = plan

  variables {
    path = "."
    custom_resource_definitions = [
      {
        path  = "."
        name  = "test.testGroup"
        group = "testGroup"
        kind  = "Test"
        versions = {
          "v1alpha1" = {
            name       = "v1alpha1"
            enabled    = true
            deprecated = true
            schema = {
              type        = "object"
              version     = "v0"
              validations = {}
              subItem = {
                stringProperty = {
                  type    = "string"
                  version = "v0"
                  subItem = null
                  validations = {
                    minLength = null
                    maxLength = null
                  }
                }
              }
            }
          }
        }
      },
    ]
    manifest = {
      apiVersion = "testGroup/v1alpha1"
      kind       = "Test"
      metadata = {
        name = "test"
      }
      spec = {
        stringProperty = "test"
      }
    }
  }

  expect_failures = [
    check.deprecated_version,
  ]
}

run "success" {
  command = plan

  variables {
    path = "."
    custom_resource_definitions = [
      {
        path  = "."
        name  = "test.testGroup"
        group = "testGroup"
        kind  = "Test"
        versions = {
          "v1alpha1" = {
            name       = "v1alpha1"
            enabled    = true
            deprecated = false
            schema = {
              type        = "object"
              version     = "v0"
              validations = {}
              subItem = {
                stringProperty = {
                  type    = "string"
                  version = "v0"
                  subItem = null
                  validations = {
                    minLength = null
                    maxLength = null
                  }
                }
              }
            }
          }
        }
      },
    ]
    manifest = {
      apiVersion = "testGroup/v1alpha1"
      kind       = "Test"
      metadata = {
        name = "test"
      }
      spec = {
        stringProperty = "test"
      }
    }
  }

  assert {
    condition = output.instance == {
      path = "."

      apiVersionName = "v1alpha1"
      apiGroup       = "testGroup"

      apiVersion = "testGroup/v1alpha1"
      kind       = "Test"
      metadata = {
        name = "test"
      }

      spec = {
        stringProperty = "test"
      }
    }
    error_message = "expected the resource to be created"
  }
}
