module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "6.10.0"

  name = "${var.env}-${var.short_region}-backstage"

  load_balancer_type          = "application"
  listener_ssl_policy_default = "ELBSecurityPolicy-TLS-1-2-2017-01"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [module.alb_security_group.security_group_id]
  # The deletion protection should be true due to the requirements
  enable_deletion_protection = false
  idle_timeout               = 4000
  internal                   = false
  desync_mitigation_mode     = "defensive"

  enable_cross_zone_load_balancing = true
  drop_invalid_header_fields       = true

  target_groups = [
    {
      name_prefix      = "demo-"
      backend_protocol = "HTTP"
      backend_port     = local.backstage_port
      target_type      = "ip"
      health_check = {
        enabled             = true
        interval            = 11
        path                = local.backstage_healthcheck_path
        port                = local.backstage_port
        healthy_threshold   = 3
        unhealthy_threshold = 8
        timeout             = 10
        protocol            = "HTTP"
        matcher             = "200"
      }
    }
  ]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      target_group_index = 0

    }
  ]


  lb_tags = {
    Owner       = var.owner
    Environment = var.env
    Team        = var.team
    CreatedBy   = var.createdBy
  }
}


