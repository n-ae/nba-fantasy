terraform {
  required_providers {
    github = {
      source  = "hashicorp/github"
      version = "5.33.0"
    }
  }
}

data "github_repository" "repo" {
  full_name = "n-ae/nba-fantasy"
}
