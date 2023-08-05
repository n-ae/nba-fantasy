data "external" "main" {
  program = [
    "${path.module}/main.sh",
    var.command,
  ]
}
