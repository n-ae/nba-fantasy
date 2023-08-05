resource "null_resource" "main" {
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
"${var.cookie_value}" \
"${var.csrf}"
EOT
    interpreter = [
      "sh",
      "-c",
    ]
  }
}
