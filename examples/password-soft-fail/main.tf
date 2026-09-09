terraform {
  required_version = ">= 1.5.0"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

# Demonstrates SOFT_MANDATORY override workflow:
# Password length is 10 (between 8 and 11 characters).
# Terrakube pauses execution at WAITING_APPROVAL, requiring an authorized
# SecOps or Admin user to submit an override approval before Apply is permitted.
resource "random_password" "db_password" {
  length           = 10
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
