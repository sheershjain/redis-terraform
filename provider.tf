provider "aws" {
  region  = "ap-south-1"
  profile = "accel"
}

terraform {
  required_version = ">= 0.13.6"

  backend "s3" {
    profile              = "accel"
    bucket               = "elastiredis"
    key                  = "staging/redis/terraform.tfstate"
    region               = "ap-south-1"
  }
 
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.10"
    }
    template = {
      source = "hashicorp/template"
    }
  }
}
