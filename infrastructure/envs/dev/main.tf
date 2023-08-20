# # [DEBUG].[backend]
# module "https-tunnel-for-backend-debug" {
#   source       = "./../../modules/env/set_dotenv"
#   file_path = abspath("./../../../backend/.env")
#   env = {
#     CORS_ALLOWED_ORIGIN = module.frontend-https-tunnel.url
#   }

#   depends_on = [
#     module.frontend-https-tunnel,
#   ]
# }

module "env" {
  source = "./../../modules/env"
}

module "frontend-https-tunnel" {
  source = "./../../modules/https-tunnel"
}

module "backend" {
  source = "./../../modules/backend"
  stage  = module.env.stage
  allow_origins = [
    module.frontend-https-tunnel.url,
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
  version       = "0.1.0"
  function_name = module.get_aws_lambda_function_name.staged_function_name
  allow_origins = [
    module.frontend-https-tunnel.url,
  ]
}

module "frontend" {
  source                      = "./../../modules/frontend"
  oauth_token_url             = module.backend.function_url
  yahoo_oauth_client_id       = var.yahoo_oauth_client_id
  cors_reverse_proxy_endpoint = module.cors-wrapper.url
}

module "update_oauth2_dev_server" {
  # developer yahoo data is inconsistent, perhaps multiple tries would help
  count       = 32
  source      = "./../../modules/developer-yahoo"
  tunnel_url  = module.frontend-https-tunnel.url
  credentials = var.yahoo_credentials
}
