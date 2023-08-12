variable "yahoo_oauth_client_id" {
  type = string
}

variable "yahoo_oauth_client_secret" {
  type = string
}

variable "github_token" {
  type        = string
  sensitive   = true
}
