locals {
  env_vars_keys = [
    "CORS_REVERSE_PROXY_ENDPOINT",
    "YAHOO_OAUTH_TOKEN_URL",
  ]
  env_vars = {
    for k, v in var.variables : k => v
    if contains(local.env_vars_keys, k) && length(v) > 0
  }
}

resource "github_actions_environment_variable" "set_environment_variables" {
  repository    = data.github_repository.repo.name
  environment   = github_repository_environment.env.environment
  count         = length(local.env_vars_keys)
  variable_name = local.env_vars_keys[count.index]
  value         = local.env_vars[local.env_vars_keys[count.index]]
}
