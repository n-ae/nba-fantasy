# [DEBUG].[backend]
# module "https-tunnel-for-backend-debug" {
#   source        = "./../../modules/env.set_dotenv"
#   project_name  = "backend"
#   ENV_VAR_NAME  = "CORS_ALLOWED_ORIGIN"
#   env_var_value = module.frontend-https-tunnel.url

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
}

module "frontend" {
  source          = "./../../modules/frontend"
  oauth_token_url = module.backend.function_url
}

module "update_oauth2_dev_server" {
  # developer yahoo data is inconsistent, perhaps multiple tries would help
  count        = 6
  source       = "./../../modules/developer-yahoo"
  tunnel_url   = module.frontend-https-tunnel.url
  cookie_value = var.yahoo_cookie_value
  csrf         = var.yahoo_csrf
}

output "update_oauth2_dev_server_results" {
  value = {
    for_each = {
      for k, v in module.update_oauth2_dev_server : k => v.http_status_code
    }
  }
}

variable "yahoo_cookie_header" {
  type = string
}
