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

data "github_repository" "repo" {
  full_name = "bali-ibrahim/nba-fantasy"
}
