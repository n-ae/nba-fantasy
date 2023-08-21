locals {
  project_dir = "./frontend"
}

data "cloudflare_accounts" "current" {}

resource "cloudflare_pages_project" "source_config" {
  account_id        = data.cloudflare_accounts.current.accounts[0].id
  name              = "nba-fantasy"
  production_branch = "main"
  source {
    type = "github"
    config {
      owner                         = "n-ae"
      repo_name                     = "nba-fantasy"
      production_branch             = "main"
      pr_comments_enabled           = true
      deployments_enabled           = true
      production_deployment_enabled = true
      #   preview_deployment_setting    = "custom"
      #   preview_branch_includes       = ["dev", ]
      #   preview_branch_excludes       = ["main", ]
    }
  }

  build_config {
    build_command   = <<EOT
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
. "$HOME/.cargo/env"
rustup target add wasm32-unknown-unknown
cargo install --locked trunk
cargo install --locked wasm-bindgen-cli

# set dotenv
touch .env
echo YAHOO_OAUTH_CLIENT_ID=${var.env.YAHOO_OAUTH_CLIENT_ID} >> .env
echo YAHOO_OAUTH_TOKEN_URL=${var.env.YAHOO_OAUTH_TOKEN_URL} >> .env
echo CORS_REVERSE_PROXY_ENDPOINT=${var.env.CORS_REVERSE_PROXY_ENDPOINT} >> .env

trunk build --public-url / --release
EOT
    destination_dir = "./dist"
    root_dir        = local.project_dir
  }
}
