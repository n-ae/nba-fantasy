resource "null_resource" "ngrok_tunnel" {
  triggers = { always_run = "${timestamp()}" }

  provisioner "local-exec" {
    command = "${path.module}/ngrok.sh"
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      pid="$(pgrep ngrok)"
      kill -9 $pid &>/dev/null &
    EOT
  }
}

data "external" "curl" {
  program = [
    "bash",
    "-c",
    "${path.module}/curl.sh"
  ]
  depends_on = [
    null_resource.ngrok_tunnel,
  ]
}
