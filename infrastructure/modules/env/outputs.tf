output "stages" {
  value = {
    dev  = "dev",
    test = "test",
    prod = "prod",
  }
}

output "stage" {
  value = basename(abspath(path.root))
}
