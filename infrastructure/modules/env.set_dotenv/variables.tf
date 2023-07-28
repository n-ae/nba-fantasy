variable "project_name" {
  type = string
  validation {
    condition     = contains(["backend", "frontend"], var.project_name)
    error_message = "Must be one of backend, frontend"
  }
}

variable "ENV_VAR_NAME" {
  type = string
}

variable "env_var_value" {
  type = string
}
