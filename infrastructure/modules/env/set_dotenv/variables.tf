variable "file_path" {
  type = string
  validation {
    condition     = contains(["backend", "frontend"], basename(dirname(var.file_path)))
    error_message = "Must be in one of:\n${join("\n", ["backend", "frontend"])}"
  }
}

variable "env" {
  type = map(string)
}
