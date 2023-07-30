resource "null_resource" "build" {
  triggers = {
    dir_sha1 = sha1(join("", [
      for f in fileset(".", "${local.backend_dir}/**") : filesha1(f)
    ]))
  }

  provisioner "local-exec" {
    command = <<-EOT
      pushd ${local.backend_dir}
      cargo lambda build --release
      pushd ./target/lambda/backend
      find . -type f -name "*" | zip -r9 -@ bootstrap.zip
    EOT
  }
}
