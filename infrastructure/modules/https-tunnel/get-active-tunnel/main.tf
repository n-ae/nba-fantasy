data "external" "main" {
  program = [
    "bash",
    "-c",
    "${path.module}/main.sh"
  ]
}
