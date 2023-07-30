module "env" {
  source = "./../env"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.9.0"
    }
  }
}

provider "aws" {
  profile = "username"
}

resource "aws_ecr_repository" "cors-anywhere" {
  name                 = "${var.stage}-cors-anywhere"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

locals {
  image_version        = "0.4.4"
  image_source         = "testcab/cors-anywhere:${local.image_version}"
  remote_image_and_tag = "${aws_ecr_repository.cors-anywhere.repository_url}:${local.image_version}"
}

data "aws_ecr_authorization_token" "token" {
}

resource "null_resource" "pull_and_push_image" {
  triggers = { always_run = "${timestamp()}" }

  provisioner "local-exec" {
    command = <<-EOT
      colima start &>/dev/null &
      docker pull ${local.image_source}
      echo ${data.aws_ecr_authorization_token.token.password} | docker login --username ${data.aws_ecr_authorization_token.token.user_name} --password-stdin ${data.aws_ecr_authorization_token.token.proxy_endpoint}
      docker tag ${local.image_source} ${local.remote_image_and_tag}
      docker push ${local.remote_image_and_tag}
    EOT
  }

  depends_on = [
    aws_ecr_repository.cors-anywhere,
    data.aws_ecr_authorization_token.token,
  ]
}
