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

provider "aws" {
  profile = "username"
}

locals {
  is_prod          = var.stage == module.env.stages.prod
  function_name    = "${var.stage}-backend"
  function_handler = "bootstrap"
  package_file     = abspath("${path.module}/../../../backend/target/lambda/backend/bootstrap.zip")
}

resource "aws_lambda_function" "backend" {
  filename         = local.package_file
  function_name    = local.function_name
  role             = "arn:aws:iam::502515897402:role/cargo-lambda-role-0b5b2467-4d2d-4433-bd9b-8e1166590954"
  handler          = local.function_handler
  source_code_hash = filebase64sha256(local.package_file)
  runtime          = "provided.al2"
  publish          = local.is_prod
  environment {
    variables = {
      # Debugging would be easier in non production environments
      RUST_BACKTRACE = !local.is_prod ? "1" : null
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
