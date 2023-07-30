locals {
  repo_vars = [
    "YAHOO_OAUTH_CLIENT_ID",
  ]
}

resource "github_actions_variable" "set_variables" {
  for_each = {
    for k, v in var.variables : k => v
    if contains(local.repo_vars, k) && length(v) > 0
  }
  repository    = data.github_repository.repo.name
  variable_name = each.key
  value         = each.value
}
