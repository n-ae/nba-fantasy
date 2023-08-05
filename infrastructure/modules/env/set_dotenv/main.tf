locals {
  project_path = "./../../../${var.project_name}"
  file_path    = "${local.project_path}/.env"
}

module "dotenv" {
  source    = "./../read_dotenv"
  file_path = local.file_path
}

locals {
  envs   = merge(module.dotenv.env, var.env)
  dotenv = join("\n", [for key, value in local.envs : "${key}=${value}"])
}

resource "null_resource" "set_dotenv" {
  triggers = {
    dotenv      = sha1(local.dotenv)
    dotenv_file = fileexists(local.file_path) ? filebase64sha256(local.file_path) : null
  }

  provisioner "local-exec" {
    command = <<-EOT
      pushd ${local.project_path}
      touch .env.tmp
      echo '${local.dotenv}' >> .env.tmp
      mv .env.tmp .env
      popd
    EOT
  }
}
