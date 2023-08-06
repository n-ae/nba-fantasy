
locals {
  package_file = abspath("${path.module}/../dist/bootstrap.zip")
}

module "get_aws_lambda_function_name" {
  source        = "../../env/get_aws_lambda_function_name"
  function_name = "cors-wrapper"
  stage         = var.stage
}

resource "aws_lambda_function" "main" {
  filename         = local.package_file
  function_name    = module.get_aws_lambda_function_name.staged_function_name
  role             = aws_iam_role.role.arn
  handler          = "index.handler"
  source_code_hash = fileexists(local.package_file) ? filebase64sha256(local.package_file) : null
  runtime          = "nodejs18.x"
  environment {
    variables = {
      PORT = 8080
    }
  }
}

resource "aws_lambda_function_url" "main" {
  function_name      = aws_lambda_function.main.function_name
  authorization_type = "NONE"

  cors {
    allow_origins = var.allow_origins
  }
}

resource "aws_lambda_permission" "allow_invoke" {
  action                 = "lambda:InvokeFunctionUrl"
  function_name          = aws_lambda_function.main.arn
  principal              = "*"
  function_url_auth_type = aws_lambda_function_url.main.authorization_type
}
