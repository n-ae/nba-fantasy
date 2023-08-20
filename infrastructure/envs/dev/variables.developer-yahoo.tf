variable "yahoo_credentials" {
  type = list(object({
    csrf         = string
    cookie_value = string
  }))
}
