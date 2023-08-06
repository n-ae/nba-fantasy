locals {
  repository_root = abspath("${path.module}/../../..")
  path = {
    repository_root = local.repository_root
    submodule       = "${local.repository_root}/cors-anywhere"
    module_abs      = abspath(path.module)
  }
}
resource "terraform_data" "bootstrap" {
  input = local.path

  provisioner "local-exec" {
    working_dir = self.input.repository_root
    command     = <<-EOT
git clone --depth 1 --branch 0.4.4 git@github.com:Rob--W/cors-anywhere.git
EOT
    interpreter = [
      "sh",
      "-c",
    ]
  }

  provisioner "local-exec" {
    working_dir = self.input.submodule
    command     = <<-EOT
cp ${local.path.module_abs}/cors-anywhere.aws_lambda_wrapper/index.js .
. ${local.path.module_abs}/cors-anywhere.aws_lambda_wrapper/npm_install.sh
EOT
    interpreter = [
      "sh",
      "-c",
    ]
  }

  provisioner "local-exec" {
    working_dir = self.input.submodule
    when        = destroy
    command     = <<-EOT
dir=$(pwd)
cd ..
rm -rf $dir
EOT
    interpreter = [
      "sh",
      "-c",
    ]
  }
}
