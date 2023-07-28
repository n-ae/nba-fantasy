resource "null_resource" "build" {
  triggers = { always_run = "${timestamp()}" }

  provisioner "local-exec" {
    command = <<-EOT
      pushd ./../../../backend
      cargo lambda build --release
      pushd ./target/lambda/backend
      find . -type f -name "*" | zip -r9 -@ bootstrap.zip
    EOT
  }
}
