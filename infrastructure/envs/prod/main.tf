module "env" {
  source = "./../../modules/env"
}

module "backend" {
  source = "./../../modules/backend"
  stage  = module.env.stage
  allow_origins = [
    "https://bali-ibrahim.github.io",
  ]
}

module "set_dotenv" {
  source        = "./../../modules/env.set_dotenv"
  project_name  = "frontend"
  ENV_VAR_NAME  = "YAHOO_OAUTH_TOKEN_URL"
  env_var_value = module.backend.function_url
}
