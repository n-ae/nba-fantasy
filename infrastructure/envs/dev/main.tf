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

module "frontend" {
  source          = "./../../modules/frontend"
  oauth_token_url = module.backend.function_url
}

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
