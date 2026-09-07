terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

# Demonstrates ADVISORY warning: Missing Owner and CostCenter tags
resource "aws_s3_bucket" "example" {
  bucket = "terrakube-opa-advisory-bucket"

  tags = {
    Environment = "dev"
  }
}
