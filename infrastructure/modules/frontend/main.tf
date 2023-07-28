module "set_dotenv" {
  source        = "./../../modules/env.set_dotenv"
  project_name  = "frontend"
  ENV_VAR_NAME  = "YAHOO_OAUTH_TOKEN_URL"
  env_var_value = var.oauth_token_url
}

resource "null_resource" "frontend" {
  triggers = { always_run = "${timestamp()}" }

  provisioner "local-exec" {
    command = "${path.module}/trunk-serve.sh"
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      kill -9 $(pgrep trunk) &>/dev/null &
    EOT
  }

  depends_on = [
    module.set_dotenv,
  ]
}
