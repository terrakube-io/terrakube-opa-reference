terraform {
  required_version = ">= 1.5.0"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

# Demonstrates ADVISORY warning:
# Password length is 14 (between 12 and 15 characters).
# Terrakube logs an ANSI warning recommending >= 16 characters,
# but does NOT block execution; the run automatically proceeds to Apply.
resource "random_password" "db_password" {
  length           = 14
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
