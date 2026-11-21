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

# Dynamic parameter FinOps scenario (~$140/mo):
# Fails bundles/finops/dynamic_budget when PolicySetParameter max_monthly_cost=100.
resource "aws_instance" "api" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "m5.xlarge"

  root_block_device {
    volume_type = "gp3"
    volume_size = 40
    encrypted   = true
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name        = "finops-parameter-api"
    Environment = "staging"
    Owner       = "platform@terrakube.io"
    CostCenter  = "CC-FINOPS-600"
  }
}
