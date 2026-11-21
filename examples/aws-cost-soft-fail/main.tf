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

# Soft-mandatory FinOps scenario (~$360/mo):
# Exceeds $200/mo delta soft limit and transitions job to waitingApproval for FinOps/Admin override.
resource "aws_instance" "compute" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "m5.2xlarge"

  root_block_device {
    volume_type = "gp3"
    volume_size = 100
    encrypted   = true
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name        = "finops-soft-fail-compute"
    Environment = "production"
    Owner       = "finops@terrakube.io"
    CostCenter  = "CC-FINOPS-300"
  }
}

resource "aws_ebs_volume" "analytics" {
  availability_zone = "us-east-1a"
  size              = 1000
  type              = "gp3"
  encrypted         = true

  tags = {
    Name        = "finops-analytics-vol"
    Environment = "production"
    Owner       = "finops@terrakube.io"
    CostCenter  = "CC-FINOPS-300"
  }
}
