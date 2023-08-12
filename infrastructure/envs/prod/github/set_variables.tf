locals {
  repo_vars_keys = [
    "YAHOO_OAUTH_CLIENT_ID",
  ]
  repo_vars = {
    for k, v in var.variables : k => v
    if contains(local.repo_vars_keys, k) && length(v) > 0
  }
}

resource "github_actions_variable" "set_variables" {
  repository    = data.github_repository.repo.name
  count         = length(local.repo_vars_keys)
  variable_name = local.repo_vars_keys[count.index]
  value         = local.repo_vars[local.repo_vars_keys[count.index]]
}
