terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "5.32.0"
    }
  }
}

provider "github" {
  token = var.token # or `GITHUB_TOKEN`
}

module "read_dotenv_frontend" {
  source    = "./../../modules/env.read_dotenv"
  file_path = "./../../../frontend/.env"
  depends_on = [
    module.set_dotenv,
  ]
}

module "read_dotenv_backend" {
  source    = "./../../modules/env.read_dotenv"
  file_path = "./../../../backend/.env"
}

data "github_repository" "repo" {
  full_name = "bali-ibrahim/nba-fantasy"
}

locals {
  yahoo_oauth_client_secret_key = "YAHOO_OAUTH_CLIENT_SECRET"
}

resource "github_actions_secret" "set_secrets_backend" {
  repository      = data.github_repository.repo.name
  secret_name     = local.yahoo_oauth_client_secret_key
  plaintext_value = module.read_dotenv_backend.dotenv[local.yahoo_oauth_client_secret_key]
}

resource "github_actions_secret" "set_secrets_frontend" {
  for_each        = module.read_dotenv_frontend.dotenv
  repository      = data.github_repository.repo.name
  secret_name     = each.key
  plaintext_value = each.value
}
