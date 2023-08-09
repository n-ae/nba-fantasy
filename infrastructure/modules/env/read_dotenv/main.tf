resource "terraform_data" "create_dotenv_if_not_exists" {
  input = {
    file_path = var.file_path,
  }

  triggers_replace = [
    var.file_path,
  ]

  provisioner "local-exec" {
    command = <<EOT
touch ${self.input.file_path}
EOT
    interpreter = [
      "sh",
      "-c",
    ]
  }
}
