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
  function_name    = "${var.stage}-backend"
  function_handler = "bootstrap"
}

resource "aws_lambda_function" "backend" {
  filename         = var.package_file
  function_name    = local.function_name
  role             = "arn:aws:iam::502515897402:role/cargo-lambda-role-0b5b2467-4d2d-4433-bd9b-8e1166590954"
  handler          = local.function_handler
  source_code_hash = filebase64sha256(var.package_file)
  runtime          = "provided.al2"
  publish          = var.stage == module.env.stage.prod
  # variables = {
  #   RUST_BACKTRACE = "1"
  # }
}

resource "aws_lambda_function_url" "backend" {
  function_name      = aws_lambda_function.backend.function_name
  authorization_type = "NONE"

  cors {
    allow_origins = var.allow_origins
  }
}


resource "aws_lambda_permission" "allow_bucket" {
  action                 = "lambda:InvokeFunctionUrl"
  function_name          = aws_lambda_function.backend.arn
  principal              = "*"
  function_url_auth_type = aws_lambda_function_url.backend.authorization_type
}
