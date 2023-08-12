locals {
  repo_secrets = [
    "YAHOO_OAUTH_CLIENT_SECRET",
  ]
  repo_secrets_env = {
    for k, v in var.variables : k => v
    if contains(local.repo_secrets, k) && length(v) > 0
  }
}

resource "github_actions_secret" "set_secrets_backend" {
  # for_each = {
  #   for k, v in var.variables : k => v
  #   if contains(local.repo_secrets, k) && length(v) > 0
  # }
  # for_each = {
  #   for k in local.repo_secrets : k => var.variables[k]
  #   if length(var.variables[k]) > 0
  # }
  repository = data.github_repository.repo.name
  # secret_name     = each.key
  # plaintext_value = each.value


  count           = length(local.repo_secrets)
  secret_name     = local.repo_secrets[count.index]
  plaintext_value = local.repo_secrets_env[local.repo_secrets[count.index]]
}
