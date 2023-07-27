output "ngrok_tunnel_url" {
  value = data.external.curl.result.result
}
