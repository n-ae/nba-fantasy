locals {
  repo_secrets_keys = [
    "YAHOO_OAUTH_CLIENT_SECRET",
  ]
  repo_secrets = {
    for k, v in var.variables : k => v
    if contains(local.repo_secrets_keys, k) && length(v) > 0
  }
}

resource "github_actions_secret" "set_secrets_backend" {
  repository      = data.github_repository.repo.name
  count           = length(local.repo_secrets_keys)
  secret_name     = local.repo_secrets_keys[count.index]
  plaintext_value = local.repo_secrets[local.repo_secrets_keys[count.index]]
}
