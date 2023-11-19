####### ECS cluster ########
module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "3.5.0"
  name    = "${var.env}-${var.short_region}-ecs"

  container_insights = true

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy = [
    {
      capacity_provider = "FARGATE"
    }
  ]

  tags = {
    Owner       = var.owner
    Environment = var.env
    Team        = var.team
    CreatedBy   = var.createdBy
  }
}
