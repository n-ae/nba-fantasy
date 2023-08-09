module "env" {
  source = "./../env"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.9.0"
    }
  }
}

locals {
  is_prod          = var.stage == module.env.stages.prod
  function_name    = "${var.stage}-backend"
  function_handler = "bootstrap"
  package_file     = abspath("${path.module}/bootstrap.zip")
}

resource "aws_lambda_function" "backend" {
  filename         = local.package_file
  function_name    = local.function_name
  role             = aws_iam_role.role.arn
  handler          = local.function_handler
  source_code_hash = fileexists(local.package_file) ? filebase64sha256(local.package_file) : null
  runtime          = "provided.al2"
  publish          = local.is_prod
  environment {
    variables = {
      # Debugging would be easier in non production environments
      RUST_BACKTRACE = !local.is_prod ? "full" : null
    }
  }

  depends_on = [
    null_resource.build,
  ]
}

resource "aws_lambda_function_url" "backend" {
  function_name      = aws_lambda_function.backend.function_name
  authorization_type = "NONE"

  cors {
    allow_origins = var.allow_origins
  }
}

resource "aws_lambda_permission" "allow_invoke" {
  action                 = "lambda:InvokeFunctionUrl"
  function_name          = aws_lambda_function.backend.arn
  principal              = "*"
  function_url_auth_type = aws_lambda_function_url.backend.authorization_type
}
