locals {
  project_name     = "frontend"
  dotenv_file_path = "./../../../${local.project_name}/.env"
  env = {
    YAHOO_OAUTH_TOKEN_URL       = var.oauth_token_url
    YAHOO_OAUTH_CLIENT_ID       = var.yahoo_oauth_client_id
    CORS_REVERSE_PROXY_ENDPOINT = var.cors_reverse_proxy_endpoint
  }
}

module "set_dotenv" {
  source       = "./../../modules/env/set_dotenv"
  project_name = local.project_name
  env          = local.env
}

module "check_frontend" {
  source  = "./../run-sh"
  command = "pgrep trunk"
}

resource "null_resource" "frontend" {
  triggers = {
    exists = length(module.check_frontend.result) > 0
    env    = join("\n", [for key, value in local.env : "${key}=${value}"])
    # env    = fileexists(local.dotenv_file_path) ? filebase64sha256(local.dotenv_file_path) : null

  }

  provisioner "local-exec" {
    command = "${path.module}/trunk-serve.sh"
    interpreter = [
      "sh",
      "-c",
    ]
  }

  provisioner "local-exec" {
    when = destroy
    # TODO: get command params dynamically
    command = <<-EOT
      kill -9 $(pgrep trunk) &>/dev/null &
      ${path.module}/../env/delete_dotenv.sh YAHOO_OAUTH_TOKEN_URL ./../../../frontend
    EOT
  }

  depends_on = [
    module.set_dotenv,
  ]
}
