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
  }
  description = "Created CLI test workspaces and their local example paths"
}

output "how_to_test" {
  value       = <<-EOT
    Test workspaces created successfully and backend.tf configured!

    To test each scenario using the CLI-driven workflow:

    1. Compliant Scenario (Expects: PASS):
       cd ../examples/compliant-workspace
       terraform init
       terraform plan

    2. Advisory Warning Scenario (Expects: ADVISORY warning in logs, run proceeds):
       cd ../examples/advisory-warning-workspace
       terraform init
       terraform plan

    3. Soft Mandatory Failure Scenario (Expects: WAITING_APPROVAL / SecOps override):
       cd ../examples/soft-fail-workspace
       terraform init
       terraform plan

    4. Hard Mandatory Failure Scenario (Expects: FAILED / apply blocked):
       cd ../examples/hard-fail-workspace
       terraform init
       terraform plan
  EOT
  description = "Step-by-step commands to run each test workspace"
}
