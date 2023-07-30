locals {
  env_vars = [
    "CORS_REVERSE_PROXY_ENDPOINT",
    "YAHOO_OAUTH_TOKEN_URL",
  ]
}

resource "github_actions_environment_variable" "set_environment_variables" {
  for_each = {
    for k, v in var.variables : k => v
    if contains(local.env_vars, k) && length(v) > 0
  }
  environment   = github_repository_environment.env.environment
  repository    = data.github_repository.repo.name
  variable_name = each.key
  value         = each.value
}
