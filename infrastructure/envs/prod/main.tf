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
