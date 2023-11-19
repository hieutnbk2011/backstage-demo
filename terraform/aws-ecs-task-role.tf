resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.env}-${var.short_region}-ecs-task-role-${var.owner}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}
