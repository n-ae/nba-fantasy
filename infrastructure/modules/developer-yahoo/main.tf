data "external" "main" {
  program = [
    "${path.module}/main.sh",
    var.tunnel_url,
    var.cookie_value,
    var.csrf,
  ]
}
