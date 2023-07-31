resource "aws_ecs_task_definition" "cors-anywhere" {
  family                   = "cors-anywhere"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.role.arn

  container_definitions = <<DEFINITION
[
  {
    "name": "cors-anywhere",
    "image": "${local.remote_image_and_tag}",
    "cpu": 1024,
    "memory": 2048,
    "essential": true
  }
]
  DEFINITION
}
