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

# Compliant S3 bucket with all mandatory tags
resource "aws_s3_bucket" "example" {
  bucket = "terrakube-opa-compliant-bucket"

  tags = {
    Environment = "production"
    Owner       = "devops@terrakube.io"
    CostCenter  = "CC-101"
  }
}

# Compliant S3 public access block (all 4 flags enabled)
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Compliant encrypted EBS volume
resource "aws_ebs_volume" "example" {
  availability_zone = "us-east-1a"
  size              = 20
  encrypted         = true

  tags = {
    Environment = "production"
    Owner       = "devops@terrakube.io"
    CostCenter  = "CC-101"
  }
}
