locals {
  repo_secrets = [
    "YAHOO_OAUTH_CLIENT_SECRET",
  ]
}

resource "github_actions_secret" "set_secrets_backend" {
  for_each = {
    for k, v in var.variables : k => v
    if contains(local.repo_secrets, k) && length(v) > 0
  }
  repository      = data.github_repository.repo.name
  secret_name     = each.key
  plaintext_value = each.value
}
