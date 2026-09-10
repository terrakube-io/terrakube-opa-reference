terraform {
  required_version = ">= 1.5.0"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

# Demonstrates combined ADVISORY warning and SOFT_MANDATORY override policy scenario:
# 1. db_password_advisory: Password length is 14 (between 12 and 15 characters).
#    Triggers the fleet-wide advisory rule 'password_length_advisory' (warning recommendation).
# 2. db_password_soft_fail: Password length is 10 (between 8 and 11 characters).
#    Triggers the soft mandatory rule 'password_length_soft_mandatory' (pauses at WAITING_APPROVAL
#    requiring authorized SecOps/Admin override approval).
# Terrakube logs both the advisory warning and the soft mandatory violation in the job policy checks output.

resource "random_password" "db_password_advisory" {
  length           = 14
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "db_password_soft_fail" {
  length           = 10
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

output "advisory_password_length" {
  value       = random_password.db_password_advisory.length
  description = "Configured advisory password length (14)"
}

output "advisory_generated_password" {
  value       = random_password.db_password_advisory.result
  sensitive   = true
  description = "Generated advisory random password"
}

output "soft_fail_password_length" {
  value       = random_password.db_password_soft_fail.length
  description = "Configured soft-fail password length (10)"
}

output "soft_fail_generated_password" {
  value       = random_password.db_password_soft_fail.result
  sensitive   = true
  description = "Generated soft-fail random password"
}
