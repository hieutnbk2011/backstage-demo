terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.67"
    }
  }
}

provider "aws" {
  region = var.region
}
