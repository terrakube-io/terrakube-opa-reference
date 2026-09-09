terraform {
  required_version = ">= 1.5.0"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

# Compliant password resource (length = 16 >= 16)
# Passes all password policies clean:
# - password-length-advisory: PASS
# - password-length-soft-mandatory: PASS
# - password-length-hard-mandatory: PASS
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
