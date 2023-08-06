variable "function_name" {
  type = string
  validation {
    condition     = length(var.function_name) <= 59
    error_message = "Function name must be less than 64 characters, including the stage prefix (up to 5 characters)"
  }
}

variable "stage" {
  type    = string
  default = "dev"
  validation {
    condition     = contains(["dev", "test", "prod"], var.stage)
    error_message = "Invalid stage"
  }
}
