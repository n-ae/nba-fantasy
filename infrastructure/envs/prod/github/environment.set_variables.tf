locals {
  env_vars = [
    "CORS_REVERSE_PROXY_ENDPOINT",
    "YAHOO_OAUTH_TOKEN_URL",
  ]
  env_vars_env = {
    for k, v in var.variables : k => v
    if contains(local.env_vars, k) && length(v) > 0
  }
}

resource "github_actions_environment_variable" "set_environment_variables" {
  # for_each = {
  #   for k, v in var.variables : k => v
  #   if contains(local.env_vars, k) && length(v) > 0
  # }
  # for_each = {
  #   for k in local.env_vars : k => var.variables[k]
  #   if length(var.variables[k]) > 0
  # }
  environment = github_repository_environment.env.environment
  repository  = data.github_repository.repo.name
  # variable_name = each.key
  # value         = each.value


  count         = length(local.env_vars)
  variable_name = local.env_vars[count.index]
  # value         = "local.env_vars_env[local.env_vars[count.index]]"
  value = local.env_vars_env[local.env_vars[count.index]]
}
