locals {
  yamls          = fileset(path.module, "./manifests/*.{yml,yaml}")
  gcp_project_id = "your_project_id"

  email_by_user = {
    for _, resource in module.tf-gapi.resources["iam.cloud.google.com/v1beta1"].User :
    (resource.metadata.name) => resource.spec.email
  }

  roles_by_user = {
    for _, resource in module.tf-gapi.resources["iam.cloud.google.com/v1beta1"].Permission :
    (resource.spec.userRef.name) => resource.spec.roles
  }

  users_by_role = transpose(local.roles_by_user)
}

module "tf-gapi" {
  source = "github.com/lukerops/tf-gapi.git"
  yamls  = local.yamls
}

resource "google_project_iam_binding" "gapi_robe_bindings" {
  for_each = local.users_by_role

  project = local.gcp_project_id
  role    = each.key
  members = [for user in each.value : "user:${local.email_by_user[user]}"]
}

output "tf-gapi" {
  value = module.tf-gapi
}
