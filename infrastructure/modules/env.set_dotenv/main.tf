resource "null_resource" "set_dotenv" {
  triggers = { always_run = "${timestamp()}" }

  provisioner "local-exec" {
    command = <<-EOT
      pushd ./../../../${var.project_name}
      grep -v '^${var.ENV_VAR_NAME}' .env > .env.tmp
      echo '${var.ENV_VAR_NAME}="${var.env_var_value}"' >> .env.tmp
      mv .env.tmp .env
    EOT
  }
}
