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

module "read_dotenv_frontend" {
  source    = "./../../modules/env.read_dotenv"
  file_path = "./../../../frontend/.env"
  depends_on = [
    module.set_dotenv,
  ]
}

module "read_dotenv_backend" {
  source    = "./../../modules/env.read_dotenv"
  file_path = "./../../../backend/.env"
}

module "github" {
  source    = "./github"
  token     = var.github_token
  variables = merge(module.read_dotenv_frontend.result, module.read_dotenv_backend.result)
  stage     = module.env.stage
}
