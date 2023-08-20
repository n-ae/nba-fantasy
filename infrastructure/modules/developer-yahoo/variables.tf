variable "tunnel_url" {
  type = string
}

variable "credentials" {
  type = list(object({
    csrf         = string
    cookie_value = string
  }))
}
