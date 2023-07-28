module "backend" {
  source = "./../modules/backend"
  stage  = local.stage
  allow_origins = [
    # "https://bali-ibrahim.github.io",
    data.external.curl.result.result,
  ]
  package_file = abspath("./../../backend/target/lambda/backend/bootstrap.zip")
}

module "frontend" {
  source          = "./../modules/frontend"
  oauth_token_url = module.backend.function_url
}
