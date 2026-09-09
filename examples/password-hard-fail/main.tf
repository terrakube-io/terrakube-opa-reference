terraform {
  required_version = ">= 1.5.0"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

# Demonstrates HARD_MANDATORY violation:
# Password length is 6 (< 8 characters).
# Terrakube strictly blocks execution, fails the job (exit code 1),
# logs ANSI red errors, and prevents Apply.
resource "random_password" "db_password" {
  length           = 6
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
