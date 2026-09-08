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

# Demonstrates SOFT_MANDATORY: When deleting multiple resources (> 5),
# Terrakube moves the job to WAITING_APPROVAL, requiring an authorized SecOps override.
# In a real workspace, running `terraform destroy` or removing these declarations triggers the rule.
resource "aws_ebs_volume" "nodes" {
  count             = 6
  availability_zone = "us-east-1a"
  size              = 10
  encrypted         = true

  tags = {
    Environment = "staging"
    Owner       = "devops@terrakube.io"
    CostCenter  = "CC-202"
  }
}
