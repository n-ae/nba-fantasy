# # [DEBUG].[backend]
# module "https-tunnel-for-backend-debug" {
#   source       = "./../../modules/env/set_dotenv"
#   project_name = "backend"
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
}

module "cors-wrapper" {
  source = "./../../modules/cors-wrapper"
  stage  = module.env.stage
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
  count        = 16
  source       = "./../../modules/developer-yahoo"
  tunnel_url   = module.frontend-https-tunnel.url
  cookie_value = var.yahoo_cookie_value
  csrf         = var.yahoo_csrf
}
