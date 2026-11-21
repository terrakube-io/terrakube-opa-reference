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

# Exempted FinOps scenario (~$5,600+/mo):
# Triggers finops_monthly_budget_hard_ceiling, waived via PolicyExemption FINOPS-101.
resource "aws_instance" "ml_cluster" {
  count         = 10
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "m5.4xlarge"

  root_block_device {
    volume_type = "gp3"
    volume_size = 100
    encrypted   = true
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name        = "finops-exempted-${count.index}"
    Environment = "production"
    Owner       = "ml@terrakube.io"
    CostCenter  = "CC-FINOPS-500"
  }
}
