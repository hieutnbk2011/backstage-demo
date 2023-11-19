##########################################
module "alb_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name        = "${var.env}-${var.short_region}-backstage-alb-${var.owner}"
  description = "Security group for backstage ALB"
  vpc_id      = module.vpc.vpc_id


  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "backstage Service"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "backstage Service https port"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Owner       = var.owner
    Environment = var.env
    Team        = var.team
    CreatedBy   = var.createdBy
  }
}

module "ecs_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name        = "${var.env}-${var.short_region}-backstage-ecs"
  description = "Security group for backstage ECS"
  vpc_id      = module.vpc.vpc_id

  egress_rules = ["all-all"]
  ingress_with_source_security_group_id = [
    {
      from_port                = local.backstage_port
      to_port                  = local.backstage_port
      protocol                 = "tcp"
      description              = "API Port"
      source_security_group_id = module.alb_security_group.security_group_id
    }
  ]

  tags = {
    Owner       = var.owner
    Environment = var.env
    Team        = var.team
    CreatedBy   = var.createdBy
  }
}

########################################################
module "container_definition" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.58.1"

  container_name               = "backstage"
  container_image              = module.ecr.repository_url
  container_memory             = local.backstage_memory
  container_memory_reservation = local.backstage_memory_reservation
  container_cpu                = local.backstage_cpu
  map_environment = {
    "HOST_URL"          = var.host_url
    "POSTGRES_HOST"     = module.db.db_instance_address
    "POSTGRES_USER"     = "demo"
    "POSTGRES_PASSWORD" = module.db.db_instance_password
    "POSTGRES_PORT"     = "5432"
    "GITHUB_TOKEN"      = var.github_token
  }
  port_mappings = [
    {
      containerPort = local.backstage_port
      hostPort      = local.backstage_port
      protocol      = "tcp"
    }
  ]
}


module "ecs_alb_service_task" {
  source = "cloudposse/ecs-alb-service-task/aws"
  # Cloud Posse recommends pinning every module to a specific version
  version = "0.64.0"

  container_definition_json          = module.container_definition.json_map_encoded_list
  alb_security_group                 = module.alb_security_group.security_group_id
  ecs_cluster_arn                    = module.ecs_cluster.ecs_cluster_arn
  launch_type                        = "FARGATE"
  vpc_id                             = module.vpc.vpc_id
  security_group_ids                 = [module.ecs_security_group.security_group_id]
  subnet_ids                         = module.vpc.private_subnets
  ignore_changes_task_definition     = true
  network_mode                       = "awsvpc"
  assign_public_ip                   = false
  propagate_tags                     = "TASK_DEFINITION"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  deployment_controller_type         = "ECS"
  desired_count                      = local.backstage_desired_count
  task_memory                        = local.backstage_task_memory
  task_cpu                           = local.backstage_task_cpu
  task_role_arn                      = [aws_iam_role.ecs_task_role.arn]
  namespace                          = var.short_region
  stage                              = var.env
  name                               = "backstage"
  ecs_load_balancers = [{
    container_name   = "backstage"
    container_port   = local.backstage_port
    elb_name         = null
    target_group_arn = element(module.alb.target_group_arns, 0)
  }]

}
