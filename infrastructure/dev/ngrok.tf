terraform {
  required_providers {
    # aws = {
    #   source  = "hashicorp/aws"
    #   version = "5.8.0"
    # }
  }
}

# provider "aws" {
#   profile = "username"
# }


locals {
  ngrok_tunnel_filename = "ngrok_tunnel.url"
}

resource "null_resource" "ngrok_tunnel" {
  triggers = { always_run = "${timestamp()}" }

  provisioner "local-exec" {
    command = "ngrok http 8080 > /dev/null & echo done"
  }

  provisioner "local-exec" {
    command = <<-EOT
      curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url' \
        > ${local.ngrok_tunnel_filename}
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      pid="$(pgrep ngrok)"
      kill -9 $pid
      wait $pid 2>/dev/null
    EOT
  }
}

data "local_file" "ngrok_tunnel_url" {
  filename   = local.ngrok_tunnel_filename
  depends_on = ["null_resource.ngrok_tunnel"]
}

output "ngrok_tunnel_url" {
  value = data.local_file.ngrok_tunnel_url.content
}
