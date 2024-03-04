run "parse_manifest_crd_v1alpha1_full_fields" {
  command = plan

  variables {
    yamls = [
      "tests/fixtures/user.gcp.iam.crd.yaml",
      "tests/fixtures/user.gcp.iam.manifest.yaml",
    ]
  }

  assert {
    condition     = abspath(module.resources[0].instance.path) == abspath("${path.module}/tests/fixtures/user.gcp.iam.manifest.yaml")
    error_message = "Não parseou manifesto correto"
  }

  assert {
    condition     = module.resources[0].instance.metadata.name == "user-teste"
    error_message = "Não paresou primeiro manifesto kind: User"
  }

  assert {
    condition     = module.resources[1].instance.metadata.name == "user-teste-2"
    error_message = "Não paresou primeiro manifesto kind: User"
  }

  assert {
    condition = {
      name   = module.resources[0].instance.spec.name,
      email  = module.resources[0].instance.spec.email
      active = module.resources[0].instance.spec.active
      points = module.resources[0].instance.spec.points
      meta   = module.resources[0].instance.spec.meta
      } == {
      email  = "user-teste@server.com"
      name   = "Usuário Teste",
      active = true
      points = [1, 2]
      meta = {
        name    = "Meta Name 1"
        number  = 42
        boolean = false
      }
    }
    error_message = "Não parseou campos do primeiro manifesto"
  }

  assert {
    condition = {
      name   = module.resources[1].instance.spec.name,
      email  = module.resources[1].instance.spec.email
      active = module.resources[1].instance.spec.active
      points = module.resources[1].instance.spec.points
      meta   = module.resources[1].instance.spec.meta
      } == {
      email  = "user-teste-2@server.com"
      name   = "Usuário Teste 2",
      active = false
      points = [3, 4]
      meta = {
        name    = "Meta Name 2"
        number  = 39
        boolean = true
      }
    }
    error_message = "Não parseou campos do primeiro manifesto"
  }

}
