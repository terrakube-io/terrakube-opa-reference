terraform {
  required_version = ">= 1.5.0"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

# Password resource configured with length 16.
# When evaluated against the 'password-length-parameter' policy set with parameter
# 'min_length = 24', this generates a hard mandatory violation because length (16) < min_length (24).
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

output "password_length" {
  value       = random_password.db_password.length
  description = "Configured password length"
}

output "generated_password" {
  value       = random_password.db_password.result
  sensitive   = true
  description = "Generated random password"
}
