output "organization_id" {
  value       = data.terrakube_organization.org.id
  description = "Target Organization UUID"
}

output "workspaces" {
  value = {
    compliant = {
      id   = terrakube_workspace_cli.compliant.id
      name = terrakube_workspace_cli.compliant.name
      path = "examples/compliant-workspace"
    }
    advisory = {
      id   = terrakube_workspace_cli.advisory.id
      name = terrakube_workspace_cli.advisory.name
      path = "examples/advisory-warning-workspace"
    }
    soft_fail = {
      id   = terrakube_workspace_cli.soft_fail.id
      name = terrakube_workspace_cli.soft_fail.name
      path = "examples/soft-fail-workspace"
    }
    hard_fail = {
      id   = terrakube_workspace_cli.hard_fail.id
      name = terrakube_workspace_cli.hard_fail.name
      path = "examples/hard-fail-workspace"
    }
    password_compliant = {
      id   = terrakube_workspace_cli.password_compliant.id
      name = terrakube_workspace_cli.password_compliant.name
      path = "examples/password-compliant"
    }
    password_advisory = {
      id   = terrakube_workspace_cli.password_advisory.id
      name = terrakube_workspace_cli.password_advisory.name
      path = "examples/password-advisory"
    }
    password_soft_fail = {
      id   = terrakube_workspace_cli.password_soft_fail.id
      name = terrakube_workspace_cli.password_soft_fail.name
      path = "examples/password-soft-fail"
    }
    password_hard_fail = {
      id   = terrakube_workspace_cli.password_hard_fail.id
      name = terrakube_workspace_cli.password_hard_fail.name
      path = "examples/password-hard-fail"
    }
  }
  description = "Created CLI test workspaces and their local example paths"
}

output "how_to_test" {
  value       = <<-EOT
    Test workspaces created successfully and backend.tf configured!

    Cloud-Free Password OPA Test Scenarios:

    1. Password Compliant (Expects: PASS - length 16):
       cd ../examples/password-compliant
       terraform init
       terraform plan

    2. Password Advisory Warning (Expects: ADVISORY warning in logs, run proceeds - length 14):
       cd ../examples/password-advisory
       terraform init
       terraform plan

    3. Password Soft Mandatory Failure (Expects: WAITING_APPROVAL / SecOps override - length 10):
       cd ../examples/password-soft-fail
       terraform init
       terraform plan

    4. Password Hard Mandatory Failure (Expects: FAILED / apply blocked - length 6):
       cd ../examples/password-hard-fail
       terraform init
       terraform plan
  EOT
  description = "Step-by-step commands to run each test workspace"
}
