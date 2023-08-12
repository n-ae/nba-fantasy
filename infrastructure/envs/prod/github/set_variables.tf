locals {
  repo_vars = [
    "YAHOO_OAUTH_CLIENT_ID",
  ]
  kvp = {
    for k, v in var.variables : k => v
    if contains(local.repo_vars, k) && length(v) > 0
  }
}

resource "github_actions_variable" "set_variables" {
  # for_each = {
  #   for k, v in var.variables : k => v
  #   if contains(local.repo_vars, k) && length(v) > 0
  # }
  # for_each = {
  #   for k in local.repo_vars : k => var.variables[k]
  #   if length(var.variables[k]) > 0
  # }
  # for_each      = local.kvp
  repository = data.github_repository.repo.name
  # variable_name = each.key
  # value         = each.value
  count         = length(local.repo_vars)
  variable_name = local.repo_vars[count.index]
  value         = local.kvp[local.repo_vars[count.index]]
}
