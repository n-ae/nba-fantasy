locals {
#   repository_root = abspath("${path.module}/../../..")
  path = {
    # repository_root = local.repository_root
    # submodule       = "${local.repository_root}/cors-anywhere"
    module_abs      = abspath(path.module)
    dist            = "${abspath(path.module)}/dist"
  }
}
resource "terraform_data" "bootstrap" {
  input = local.path

  provisioner "local-exec" {
    working_dir = self.input.module_abs
    command     = <<-EOT
git clone --depth 1 --branch 0.4.4 git@github.com:Rob--W/cors-anywhere.git ${self.input.dist}
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
. ${self.input.module_abs}/aws_lambda_wrapper/npm_install.sh
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
