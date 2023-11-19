resource "aws_iam_role" "ecs_task_execution" {
  name               = "${var.env}-${var.short_region}-execution-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

module "ecr" {
  source = "cloudposse/ecr/aws"
  version = "0.34.0"
  namespace    = var.short_region
  stage        = var.env
  name         = "backstage"
  image_tag_mutability = "MUTABLE"
  use_fullname = false
  image_names  = ["backstage"]
  principals_full_access = [aws_iam_role.ecs_task_execution.arn]

  tags = {
    Owner       = var.owner
    Environment = var.env
    Team        = var.team
    CreatedBy   = var.createdBy
  }
}
