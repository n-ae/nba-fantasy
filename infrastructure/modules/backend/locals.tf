locals {
  file_path   = abspath("${path.module}/../../../backend/.env")
  backend_dir = dirname(local.file_path)
  env = {
    YAHOO_OAUTH_CLIENT_ID     = var.yahoo_oauth_client_id
    YAHOO_OAUTH_CLIENT_SECRET = var.yahoo_oauth_client_secret
  }
}
