output "env" {
  value = { for tuple in regexall("(.*?)=\"?(.*?)\"", fileexists(terraform_data.create_dotenv_if_not_exists.output.file_path) ? file(terraform_data.create_dotenv_if_not_exists.output.file_path) : "") : tuple[0] => tuple[1] }
}
