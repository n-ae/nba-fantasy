resource "null_resource" "frontend" {
  triggers = { always_run = "${timestamp()}" }

  provisioner "local-exec" {
    command = <<-EOT
      pushd ./../../../frontend
      grep -v '^YAHOO_OAUTH_TOKEN_URL' .env > .env.tmp
      echo 'YAHOO_OAUTH_TOKEN_URL="${var.oauth_token_url}"' >> .env.tmp
      mv .env.tmp .env
    EOT
  }

  provisioner "local-exec" {
    command = "${path.module}/trunk-serve.sh"
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      kill -9 $(pgrep trunk) &>/dev/null &
    EOT
  }
}
