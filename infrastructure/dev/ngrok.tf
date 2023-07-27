# terraform {
#   required_providers {
#     # aws = {
#     #   source  = "hashicorp/aws"
#     #   version = "5.8.0"
#     # }
#   }
# }

# provider "aws" {
#   profile = "username"
# }


locals {
  ngrok_tunnel_filename = "ngrok_tunnel.url"
}

resource "null_resource" "ngrok_tunnel" {
  triggers = { always_run = "${timestamp()}" }

  provisioner "local-exec" {
    command = "./ngrok.sh"
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      pid="$(pgrep ngrok)"
      kill -9 $pid
    EOT
  }
}

data "external" "curl" {
  program = [
    "bash",
    "-c",
    "./curl.sh"
  ]
  depends_on = [
    null_resource.ngrok_tunnel,
  ]
}

output "ngrok_tunnel_url" {
  value = data.external.curl.result.result
}
