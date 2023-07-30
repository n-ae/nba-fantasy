output "dotenv" {
  value = { for tuple in regexall("(.*?)=(.*)", file(var.file_path)) : tuple[0] => tuple[1] }
}
