resource "null_resource" "main" {
  count = length(var.credentials)
  triggers = {
    tunnel_url = var.tunnel_url
    dir_sha1 = sha1(join("", [
      for f in fileset(".", "${path.module}/**") : filesha1(f)
    ]))
  }

  provisioner "local-exec" {
    working_dir = path.module
    command     = <<EOT
./main.sh \
"${var.tunnel_url}" \
"${var.credentials[count.index].cookie_value}" \
"${var.credentials[count.index].csrf}"
EOT
    interpreter = [
      "sh",
      "-c",
    ]
  }
}
