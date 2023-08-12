variable "project_name" {
  type = string
  # validation {
  #   condition     = contains(["backend", "frontend"], var.project_name)
  #   error_message = "Must be one of backend, frontend"
  # }
}

variable "file_path" {
  type = string
}

variable "env" {
  type = map(string)
}
