terraform {
  required_version = ">= 1.5.0"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

# Demonstrates POLICY EXEMPTION workflow:
# Password length is 6 (< 8 characters), which triggers the hard-mandatory
# rule 'password_length_hard_mandatory'.
# However, this workspace carries an active PolicyExemption (e.g. ticket SEC-101),
# allowing the in-runner OPA engine to bypass the violation and transition
# the evaluation status to PASSED (WITH EXEMPTION), permitting Apply to proceed.
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
