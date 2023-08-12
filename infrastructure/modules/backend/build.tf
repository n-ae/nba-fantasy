module "set_dotenv" {
  source    = "./../../modules/env/set_dotenv"
  file_path = local.file_path
  env       = local.env
}

locals {
  module_abs_path = abspath(path.module)
}

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
      mv bootstrap.zip ${local.module_abs_path}
    EOT
  }

  depends_on = [
    module.set_dotenv,
  ]
}
