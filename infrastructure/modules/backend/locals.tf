locals {
  project_name = "backend"
  backend_dir  = "./../../../${local.project_name}"
  env = {
    YAHOO_OAUTH_CLIENT_ID     = var.yahoo_oauth_client_id
    YAHOO_OAUTH_CLIENT_SECRET = var.yahoo_oauth_client_secret
  }
}
