variable "stage" {
  type = string
  #   default = "dev"
  #   validation {
  #     condition = contains(["dev", "test", "prod"], var.env)
  #   }
}

variable "allow_origins" {
  type = list(string)
}
