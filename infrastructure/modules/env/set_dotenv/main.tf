locals {
  project_path = abspath("${path.module}./../../../../${var.project_name}")
  file_path    = "${local.project_path}/.env"
}

module "dotenv" {
  source    = "./../read_dotenv"
  file_path = local.file_path
}

locals {
  env    = merge(module.dotenv.env, var.env)
  dotenv = join("\n", [for key, value in local.env : "${key}=${value}"])
}

resource "null_resource" "set_dotenv" {
  triggers = {
    env = sha1(local.dotenv)
  }

  provisioner "local-exec" {
    working_dir = local.project_path
    command     = <<-EOT
      touch .env.tmp
      echo '${local.dotenv}' >> .env.tmp
      mv .env.tmp .env
EOT
    interpreter = [
      "sh",
      "-c",
    ]
  }
}
