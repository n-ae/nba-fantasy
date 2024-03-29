module "env" {
  source = "./../../modules/env"
}

locals {
  frontend_endpoint = "https://n-ae.github.io"
}

module "backend" {
  source = "./../../modules/backend"
  stage  = module.env.stage
  allow_origins = [
    local.frontend_endpoint,
  ]
  yahoo_oauth_client_id     = var.yahoo_oauth_client_id
  yahoo_oauth_client_secret = var.yahoo_oauth_client_secret
}

module "get_aws_lambda_function_name" {
  source        = "../../modules/env/get_aws_lambda_function_name"
  function_name = "cors-wrapper"
  stage         = module.env.stage
}

module "cors-wrapper" {
  source        = "n-ae/lambda-cors-anywhere/aws"
  version       = "0.3.1"
  function_name = module.get_aws_lambda_function_name.staged_function_name
  allow_origins = [
    local.frontend_endpoint,
  ]
}

module "set_dotenv" {
  source    = "./../../modules/env/set_dotenv"
  file_path = abspath("./../../../frontend/.env")
  env = {
    YAHOO_OAUTH_TOKEN_URL       = module.backend.function_url
    CORS_REVERSE_PROXY_ENDPOINT = module.cors-wrapper.url
  }
}

module "read_dotenv_frontend" {
  source    = "./../../modules/env/read_dotenv"
  file_path = abspath("./../../../frontend/.env")
  depends_on = [
    module.set_dotenv,
  ]
}

module "read_dotenv_backend" {
  source    = "./../../modules/env/read_dotenv"
  file_path = abspath("./../../../backend/.env")
  depends_on = [
    module.backend,
  ]
}

locals {
  env = merge(module.read_dotenv_frontend.env, module.read_dotenv_backend.env)
}

module "github" {
  source    = "./github"
  token     = var.github_token
  variables = local.env
  stage     = module.env.stage
}
