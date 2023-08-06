locals {
  path = {
    module_abs = abspath(path.module)
    dist       = "${abspath(path.module)}/dist"
  }
}

resource "terraform_data" "dist" {
  input = local.path

  provisioner "local-exec" {
    working_dir = self.input.module_abs
    command     = <<-EOT
git clone --depth 1 --branch 0.4.4 git@github.com:Rob--W/cors-anywhere.git ${self.input.dist} &2>/dev/null
EOT
    interpreter = [
      "sh",
      "-c",
    ]
  }

  provisioner "local-exec" {
    working_dir = self.input.dist
    command     = <<-EOT
cp ${self.input.module_abs}/aws_lambda_wrapper/index.js .
. ${self.input.module_abs}/aws_lambda_wrapper/build.sh
EOT
    interpreter = [
      "sh",
      "-c",
    ]
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
rm -rf ${self.input.dist}
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
