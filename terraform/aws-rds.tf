module "db_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "${var.env}-${var.owner}-database"
  description = "Complete PostgreSQL security group"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
        {
          from_port   = 5432
          to_port     = 5432
          protocol    = "tcp"
          description = "PostgreSQL access from ecs"
          source_security_group_id= module.ecs_security_group.security_group_id
        }
  ]
  egress_rules = ["all-all"]
  tags = {
    Owner       = var.owner
    Environment = var.env
  }
}


module "db" {
  source     = "terraform-aws-modules/rds/aws"
  version    = "5.9.0"
  identifier = "${var.env}-${var.owner}-db"

  # All available versions: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts
  engine               = "postgres"
  engine_version       = "15.4"
  family               = "postgres15" # DB parameter group
  major_engine_version = "15"         # DB option group
  instance_class       = "db.t3.micro"

  allocated_storage      = 20
  max_allocated_storage  = 100
  create_random_password = true
  db_name                = "demo"
  username               = "demo"
  port                   = 5432

  multi_az = false

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = module.vpc.private_subnets
  vpc_security_group_ids = [module.db_security_group.security_group_id]

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  create_cloudwatch_log_group     = true

  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  create_monitoring_role                = true
  monitoring_interval                   = 60
  monitoring_role_name                  = "${var.env}-${var.owner}-db-monitoring"
  monitoring_role_description           = "Description for monitoring role"
  tags = {
    Owner       = var.owner
    Environment = var.env
  }
  parameters = [
    {
      name  = "autovacuum"
      value = 1
    },
    {
      name  = "client_encoding"
      value = "utf8"
    }
  ]

  db_option_group_tags = {
    "Sensitive" = "low"
  }
  db_parameter_group_tags = {
    "Sensitive" = "low"
  }
}
