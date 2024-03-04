
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
