
run "parse_crd_with_multiple_versions" {
  command = plan

  variables {
    yamls = [
      "tests/fixtures/user.gcp.iam.crd_with_multiple_versions.yaml"
    ]
  }

  assert {
    condition     = length(module.custom_resource_definitions_v1alpha1[0].schemas) == 4
    error_message = "Não parseou todas as versões do CRD"
  }

}

##################################################
# Sem tipos complexos:
#type(module.custom_resource_definitions_v1alpha1[0].schemas)
#tuple([
#    object({
#        apiVersion: string,
#        deprecated: bool,
#        enabled: bool,
#        kind: string,
#        path: string,
#        specSchema: object({
#            active: object({
#                description: dynamic,
#                externalDocs: dynamic,
#                type: string,
#            }),
#            namme: object({
#                description: dynamic,
#                externalDocs: dynamic,
#                maxLength: dynamic,
#                minLength: dynamic,
#                type: string,
#            }),
#        }),
#    }),
#    object({
#        apiVersion: string,
#        deprecated: bool,
#        enabled: bool,
#        kind: string,
#        path: string,
#        specSchema: object({
#            namme: object({
#                description: dynamic,
#                externalDocs: dynamic,
#                maxLength: dynamic,
#                minLength: dynamic,
#                type: string,
#            }),
#        }),
#    }),
#    object({
#        apiVersion: string,
#        deprecated: bool,
#        enabled: bool,
#        kind: string,
#        path: string,
#        specSchema: object({
#            active: object({
#                description: dynamic,
#                externalDocs: dynamic,
#                type: string,
#            }),
#            namme: object({
#                description: dynamic,
#                externalDocs: dynamic,
#                maxLength: dynamic,
#                minLength: dynamic,
#                type: string,
#            }),
#        }),
#    }),
#    object({
#        apiVersion: string,
#        deprecated: bool,
#        enabled: bool,
#        kind: string,
#        path: string,
#        specSchema: object({
#            namme: object({
#                description: dynamic,
#                externalDocs: dynamic,
#                maxLength: dynamic,
#                minLength: dynamic,
#                type: string,
#            }),
#        }),
#    }),
#])
#
#> tolist(module.custom_resource_definitions_v1alpha1[0].schemas)
#tolist([
#  {
#    "apiVersion" = "gcp.iam/v1alpha1"
#    "deprecated" = false
#    "enabled" = true
#    "kind" = "User"
#    "path" = "tests/fixtures/user.gcp.iam.crd_with_multiple_versions.yaml"
#    "specSchema" = tomap({
#      "active" = tomap({
#        "description" = tostring(null)
#        "externalDocs" = tostring(null)
#        "type" = "bool"
#      })
#      "namme" = tomap({
#        "description" = tostring(null)
#        "externalDocs" = tostring(null)
#        "maxLength" = tostring(null)
#        "minLength" = tostring(null)
#        "type" = "string"
#      })
#    })
#  },
#  {
#    "apiVersion" = "gcp.iam/v1alpha2"
#    "deprecated" = false
#    "enabled" = true
#    "kind" = "User"
#    "path" = "tests/fixtures/user.gcp.iam.crd_with_multiple_versions.yaml"
#    "specSchema" = tomap({
#      "namme" = tomap({
#        "description" = tostring(null)
#        "externalDocs" = tostring(null)
#        "maxLength" = tostring(null)
#        "minLength" = tostring(null)
#        "type" = "string"
#      })
#    })
#  },
#  {
#    "apiVersion" = "gcp.iam/v1alpha3"
#    "deprecated" = false
#    "enabled" = true
#    "kind" = "User"
#    "path" = "tests/fixtures/user.gcp.iam.crd_with_multiple_versions.yaml"
#    "specSchema" = tomap({
#      "active" = tomap({
#        "description" = tostring(null)
#        "externalDocs" = tostring(null)
#        "type" = "bool"
#      })
#      "namme" = tomap({
#        "description" = tostring(null)
#        "externalDocs" = tostring(null)
#        "maxLength" = tostring(null)
#        "minLength" = tostring(null)
#        "type" = "string"
#      })
#    })
#  },
#  {
#    "apiVersion" = "gcp.iam/v1alpha4"
#    "deprecated" = false
#    "enabled" = true
#    "kind" = "User"
#    "path" = "tests/fixtures/user.gcp.iam.crd_with_multiple_versions.yaml"
#    "specSchema" = tomap({
#      "namme" = tomap({
#        "description" = tostring(null)
#        "externalDocs" = tostring(null)
#        "maxLength" = tostring(null)
#        "minLength" = tostring(null)
#        "type" = "string"
#      })
#    })
#  },
#])


# Com tipo complexo
#> type(module.custom_resource_definitions_v1alpha1[0].versions)
#tuple([
#    object({
#        name: string,
#        specSchema: object({
#            properties: object({
#                active: object({
#                    type: string,
#                }),
#                extra: object({
#                    items: object({
#                        type: string,
#                    }),
#                    type: string,
#                }),
#                namme: object({
#                    type: string,
#                }),
#            }),
#            type: string,
#        }),
#    }),
#    object({
#        name: string,
#        specSchema: object({
#            properties: object({
#                namme: object({
#                    type: string,
#                }),
#            }),
#            type: string,
#        }),
#    }),
#    object({
#        name: string,
#        specSchema: object({
#            properties: object({
#                active: object({
#                    type: string,
#                }),
#                namme: object({
#                    type: string,
#                }),
#            }),
#            type: string,
#        }),
#    }),
#    object({
#        name: string,
#        specSchema: object({
#            properties: object({
#                namme: object({
#                    type: string,
#                }),
#            }),
#            type: string,
#        }),
#    }),
#])
#
#> tolist(module.custom_resource_definitions_v1alpha1[0].versions)
#╷
#│ Error: Invalid function argument
#│ 
#│   on <console-input> line 1:
#│   (source code not available)
#│ 
#│ Invalid value for "v" parameter: cannot convert tuple to list of any single type.
#╵
#
#
#
