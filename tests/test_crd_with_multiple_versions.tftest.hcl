run "parse_crd_with_multiple_versions" {
  command = plan

  variables {
    yamls = [
      "tests/fixtures/user.gcp.iam.crd_with_multiple_versions.yaml"
    ]
  }

  assert {
    condition     = length(module.custom_resource_definitions[0].schema.versions) == 4
    error_message = "Não parseou todas as versões do CRD"
  }
}
