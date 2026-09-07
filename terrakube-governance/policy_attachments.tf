# ==============================================================================
# Policy Attachments for Compliant Test Workspace
# (Attached to all policy sets to prove clean passing evaluation)
# ==============================================================================
resource "terrakube_policy_attachment" "compliant_tagging" {
  policy_set_id = terrakube_policy_set.common_tagging.id
  workspace_id  = terrakube_workspace_cli.compliant.id
}

resource "terrakube_policy_attachment" "compliant_blast_radius" {
  policy_set_id = terrakube_policy_set.blast_radius.id
  workspace_id  = terrakube_workspace_cli.compliant.id
}

resource "terrakube_policy_attachment" "compliant_aws_baseline" {
  policy_set_id = terrakube_policy_set.aws_baseline.id
  workspace_id  = terrakube_workspace_cli.compliant.id
}

resource "terrakube_policy_attachment" "compliant_azure_baseline" {
  policy_set_id = terrakube_policy_set.azure_baseline.id
  workspace_id  = terrakube_workspace_cli.compliant.id
}

resource "terrakube_policy_attachment" "compliant_gcp_baseline" {
  policy_set_id = terrakube_policy_set.gcp_baseline.id
  workspace_id  = terrakube_workspace_cli.compliant.id
}

# ==============================================================================
# Policy Attachments for Advisory Warning Test Workspace
# (Attached to Common Tagging to demonstrate non-blocking ANSI warning flow)
# ==============================================================================
resource "terrakube_policy_attachment" "advisory_tagging" {
  policy_set_id = terrakube_policy_set.common_tagging.id
  workspace_id  = terrakube_workspace_cli.advisory.id
}

# ==============================================================================
# Policy Attachments for Soft Mandatory Test Workspace
# (Attached to Blast Radius to demonstrate WAITING_APPROVAL SecOps override flow)
# ==============================================================================
resource "terrakube_policy_attachment" "soft_fail_blast_radius" {
  policy_set_id = terrakube_policy_set.blast_radius.id
  workspace_id  = terrakube_workspace_cli.soft_fail.id
}

# ==============================================================================
# Policy Attachments for Hard Mandatory Test Workspace
# (Attached to Cloud Baselines to demonstrate exitCode=1 apply blocking)
# ==============================================================================
resource "terrakube_policy_attachment" "hard_fail_aws_baseline" {
  policy_set_id = terrakube_policy_set.aws_baseline.id
  workspace_id  = terrakube_workspace_cli.hard_fail.id
}

resource "terrakube_policy_attachment" "hard_fail_azure_baseline" {
  policy_set_id = terrakube_policy_set.azure_baseline.id
  workspace_id  = terrakube_workspace_cli.hard_fail.id
}

resource "terrakube_policy_attachment" "hard_fail_gcp_baseline" {
  policy_set_id = terrakube_policy_set.gcp_baseline.id
  workspace_id  = terrakube_workspace_cli.hard_fail.id
}
