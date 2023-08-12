module "dotenv" {
  source    = "./../read_dotenv"
  file_path = var.file_path
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
    working_dir = dirname(var.file_path)
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
