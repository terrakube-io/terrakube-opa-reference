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
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

# Advisory FinOps scenario (~$150+/mo with usage-based S3 estimate):
# Triggers finops_high_cost_resource advisory warning on m5.xlarge (~$140/mo)
# without blocking deployment.
resource "aws_instance" "app" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "m5.xlarge"

  root_block_device {
    volume_type = "gp3"
    volume_size = 50
    encrypted   = true
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name        = "finops-advisory-app"
    Environment = "staging"
    Owner       = "platform@terrakube.io"
    CostCenter  = "CC-FINOPS-200"
  }
}

resource "aws_s3_bucket" "artifacts" {
  bucket = "terrakube-finops-advisory-artifacts"

  tags = {
    Environment = "staging"
    Owner       = "platform@terrakube.io"
    CostCenter  = "CC-FINOPS-200"
  }
}
