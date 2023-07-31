data "aws_iam_policy_document" "policy_document" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


data "aws_iam_policy" "exec_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "role" {
  assume_role_policy = data.aws_iam_policy_document.policy_document.json
  managed_policy_arns = [
    data.aws_iam_policy.exec_policy.arn,
  ]
}
