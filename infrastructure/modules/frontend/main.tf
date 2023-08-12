locals {
  get_trunk_server_process_id_command = "pgrep trunk"
  dotenv_file_path                    = abspath("./../../../frontend/.env")
  env = {
    YAHOO_OAUTH_TOKEN_URL       = var.oauth_token_url
    YAHOO_OAUTH_CLIENT_ID       = var.yahoo_oauth_client_id
    CORS_REVERSE_PROXY_ENDPOINT = var.cors_reverse_proxy_endpoint
  }
}

module "set_dotenv" {
  source    = "./../../modules/env/set_dotenv"
  file_path = local.dotenv_file_path
  env       = local.env
}

module "check_frontend" {
  source  = "./../run-sh"
  command = local.get_trunk_server_process_id_command
}


resource "terraform_data" "frontend" {
  input = {
    get_trunk_server_process_id_command = local.get_trunk_server_process_id_command
    dotenv_file_path                    = local.dotenv_file_path
  }

  triggers_replace = {
    exists = length(module.check_frontend.result) > 0
    env    = sha1(join("\n", [for key, value in local.env : "${key}=${value}"]))
  }

  provisioner "local-exec" {
    command = "${path.module}/trunk-serve.sh"
    interpreter = [
      "sh",
      "-c",
    ]
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      kill -9 $(${self.input.get_trunk_server_process_id_command}) &>/dev/null &
      ${path.module}/../env/delete_dotenv.sh YAHOO_OAUTH_TOKEN_URL ${self.input.dotenv_file_path}
    EOT
  }

  depends_on = [
    module.set_dotenv,
  ]
}
