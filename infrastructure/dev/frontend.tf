resource "null_resource" "frontend" {
  triggers = { always_run = "${timestamp()}" }

  provisioner "local-exec" {
    command = <<-EOT
      pushd ./../../frontend
      grep -v '^YAHOO_OAUTH_TOKEN_URL' .env > .env.tmp
      echo 'YAHOO_OAUTH_TOKEN_URL="${module.backend.function_url}"' >> .env.tmp
      mv .env.tmp .env
    EOT

    # environment = {
    #   YAHOO_OAUTH_TOKEN_URL = aws_lambda_function_url.backend.function_url
    # }
  }


  # provisioner "local-exec" {
  #   command = "echo $YAHOO_OAUTH_TOKEN_URL >> .env"

  #   environment = {
  #     YAHOO_OAUTH_TOKEN_URL = aws_lambda_function_url.backend.function_url
  #   }
  # }

  provisioner "local-exec" {
    command = <<-EOT
      pushd ./../../frontend
      cargo clean
      trunk serve &>/dev/null &
    EOT
  }

  provisioner "local-exec" {
    when = destroy
    command = <<-EOT
      kill -9 $(pgrep trunk) &>/dev/null &
    EOT
  }
}

# locals {
#   env_file_content = <<EOT
# YAHOO_OAUTH_TOKEN_URL=${format("%q", aws_lambda_function_url.backend.function_url)}
# EOT
# }
