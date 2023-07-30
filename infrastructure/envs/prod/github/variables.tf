variable "token" {
  # create a PAT here:
  # https://github.com/settings/personal-access-tokens/new
  # with:
  # Administration:write
  # Environments:write
  # Secrets:write
  # Variables:write

  type        = string
  description = "Specifies the GitHub PAT token or `GITHUB_TOKEN`"
  sensitive   = true
}

variable "stage" {
  type = string
}

variable "variables" {
  type = map(string)
}
