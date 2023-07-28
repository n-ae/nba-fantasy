module "env" {
  source = "./../../modules/env"
}

module "backend" {
  source = "./../../modules/backend"
  stage  = module.env.stage
  allow_origins = [
    # "https://bali-ibrahim.github.io",
    module.frontend-https-tunnel.url,
  ]
}

module "frontend" {
  source          = "./../../modules/frontend"
  oauth_token_url = module.backend.function_url
}

module "frontend-https-tunnel" {
  source = "./../../modules/https-tunnel"
}
