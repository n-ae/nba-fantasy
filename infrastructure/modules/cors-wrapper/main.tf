locals {
  cors_anywhere_version = "0.4.4"
  path = {
    module_abs = abspath(path.module)
    dist       = "${abspath(path.module)}/dist"
  }
}

resource "terraform_data" "dist" {
  input = {
    path                  = local.path,
    cors_anywhere_version = local.cors_anywhere_version
  }

  triggers_replace = local.cors_anywhere_version

  provisioner "local-exec" {
    working_dir = self.input.path.module_abs
    command     = <<-EOT
git clone --depth 1 --branch ${self.input.cors_anywhere_version} git@github.com:Rob--W/cors-anywhere.git ${self.input.path.dist} &2>/dev/null
EOT
    interpreter = [
      "sh",
      "-c",
    ]
  }

  provisioner "local-exec" {
    working_dir = self.input.path.dist
    command     = <<-EOT
cp ${self.input.path.module_abs}/aws_lambda_wrapper/index.js .
. ${self.input.path.module_abs}/aws_lambda_wrapper/build.sh
EOT
    interpreter = [
      "sh",
      "-c",
    ]
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
rm -rf ${self.input.path.dist}
EOT
    interpreter = [
      "sh",
      "-c",
    ]
  }
}

module "aws" {
  source        = "./aws"
  stage         = var.stage
  allow_origins = var.allow_origins

  depends_on = [
    terraform_data.dist,
  ]
}
