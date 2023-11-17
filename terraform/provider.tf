terraform {
  cloud {
    organization = "hieutnbk2011"

    workspaces {
      name = "backstage-demo"
    }
  }
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "4.67"
   }
 }
}

provider "aws" {
 region = "ap-southeast-2"
}
