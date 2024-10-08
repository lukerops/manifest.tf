run "valida_output_por_apigroup" {
  command = plan
  variables {
    yamls = [
      "tests/fixtures/user.gcp.iam.crd.yaml",
      "tests/fixtures/user.gcp.iam.manifest.yaml",
    ]
  }

  assert {
    condition     = contains(keys(module.groupResources.groupedResources), "gcp.iam")
    error_message = "GroupResources não agrupou por apigroup gcp.iam"
  }

  assert {
    condition     = length(keys(module.groupResources.groupedResources)) == 1
    error_message = "Deveria haver apenas um apigroup: gcp.iam"
  }

}

run "valida_output_por_kind" {
  command = plan
  variables {
    yamls = [
      "tests/fixtures/user.gcp.iam.crd.yaml",
      "tests/fixtures/user.gcp.iam.manifest.yaml",
    ]
  }


  assert {
    condition = length(
      keys(
        try(module.groupResources.groupedResources["gcp.iam"]["User"], {})
      )
    ) == 2
    error_message = "Não agrupou pelo kind User"
  }
}
