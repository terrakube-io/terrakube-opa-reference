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
  access_key                  = "mock_key"
  secret_key                  = "mock_secret"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

# Demonstrates HARD_MANDATORY violation:
# 1. EBS volume is unencrypted (encrypted = false)
# 2. S3 Public Access Block leaves public ACLs open (block_public_acls = false)
# Terrakube strictly aborts the run and prevents apply.
resource "aws_ebs_volume" "insecure" {
  availability_zone = "us-east-1a"
  size              = 50
  encrypted         = false

  tags = {
    Environment = "production"
    Owner       = "devops@terrakube.io"
    CostCenter  = "CC-303"
  }
}

resource "aws_s3_bucket" "insecure" {
  bucket = "terrakube-opa-insecure-bucket"

  tags = {
    Environment = "production"
    Owner       = "devops@terrakube.io"
    CostCenter  = "CC-303"
  }
}

resource "aws_s3_bucket_public_access_block" "insecure" {
  bucket = aws_s3_bucket.insecure.id

  block_public_acls       = false # Hard failure!
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
