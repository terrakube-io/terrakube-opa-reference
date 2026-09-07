# Attach Common Tagging Policy Set to all target workspaces
resource "terrakube_policy_attachment" "tagging_workspaces" {
  for_each      = toset(var.workspace_ids)
  policy_set_id = terrakube_policy_set.common_tagging.id
  workspace_id  = each.value
}

# Attach Blast Radius Policy Set to all target workspaces
resource "terrakube_policy_attachment" "blast_radius_workspaces" {
  for_each      = toset(var.workspace_ids)
  policy_set_id = terrakube_policy_set.blast_radius.id
  workspace_id  = each.value
}

# Attach AWS Baseline to all target workspaces
resource "terrakube_policy_attachment" "aws_baseline_workspaces" {
  for_each      = toset(var.workspace_ids)
  policy_set_id = terrakube_policy_set.aws_baseline.id
  workspace_id  = each.value
}
