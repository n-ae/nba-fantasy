variable "project_name" {
  type = string
  validation {
    condition     = contains(["backend", "frontend"], var.project_name)
    error_message = "Must be one of backend, frontend"
  }
}

variable "env" {
  type = map(string)
}
