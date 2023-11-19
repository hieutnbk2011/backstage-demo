module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"
  name    = "${var.env}-${var.short_region}-vpc"
  cidr    = var.cidr_block

  azs                          = var.availability_zones
  private_subnets              = var.app_private_subnets
  public_subnets               = var.public_subnets
  database_subnets             = var.db_private_subnet
  create_database_subnet_group = true
  enable_nat_gateway           = true
  single_nat_gateway           = true
  enable_dns_hostnames         = true
  enable_dns_support           = true
  enable_vpn_gateway           = false

  tags = {
    Owner       = var.owner
    Environment = var.env
    Team        = var.team
    CreatedBy   = var.createdBy
  }
}
