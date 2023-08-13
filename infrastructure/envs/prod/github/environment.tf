data "github_user" "current" {
  username = "n-ae"
}

resource "github_repository_environment" "env" {
  repository  = data.github_repository.repo.name
  environment = var.stage
  # wait_timer  = 10000
  reviewers {
    users = [data.github_user.current.id]
  }
  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }
}

resource "github_repository_environment_deployment_policy" "env" {
  repository     = data.github_repository.repo.name
  environment    = github_repository_environment.env.environment
  branch_pattern = "main"
}
