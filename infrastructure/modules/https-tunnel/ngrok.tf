module "pre-get-active-tunnel" {
  source = "./get-active-tunnel"
}

resource "null_resource" "ngrok_tunnel" {
  triggers = {
    exists = length(module.pre-get-active-tunnel.url) > 0
  }
  # count = length(module.pre-get-active-tunnel.url) > 0 ? 0 : 1
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

module "post-get-active-tunnel" {
  source = "./get-active-tunnel"
  depends_on = [
    null_resource.ngrok_tunnel,
  ]
}

# data "external" "curl" {
#   program = [
#     "bash",
#     "-c",
#     "${path.module}/curl.sh"
#   ]
#   depends_on = [
#     null_resource.ngrok_tunnel,
#   ]
# }
