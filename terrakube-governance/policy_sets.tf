# 1. Advisory Tagging Policy Set
resource "terrakube_policy_set" "common_tagging" {
  organization_id   = var.organization_id
  name              = "common-mandatory-tagging"
  description       = "Advisory guardrail requiring Environment, Owner, and CostCenter tags on all cloud resources"
  enforcement_level = "advisory"
  vcs_id            = var.vcs_id
  repository        = var.policy_repo
  branch            = var.policy_branch
  path              = "bundles/common/tagging"
}

# 2. Soft Mandatory Blast Radius Policy Set
resource "terrakube_policy_set" "blast_radius" {
  organization_id   = var.organization_id
  name              = "common-blast-radius"
  description       = "Soft mandatory guardrail requiring SecOps override approval if deletions exceed safe thresholds"
  enforcement_level = "soft_mandatory"
  vcs_id            = var.vcs_id
  repository        = var.policy_repo
  branch            = var.policy_branch
  path              = "bundles/common/blast_radius"
}

# 3. Hard Mandatory AWS Baseline Policy Set
resource "terrakube_policy_set" "aws_baseline" {
  organization_id   = var.organization_id
  name              = "aws-security-baseline"
  description       = "Hard mandatory guardrail enforcing S3 block public access, EBS encryption, and IMDSv2"
  enforcement_level = "hard_mandatory"
  vcs_id            = var.vcs_id
  repository        = var.policy_repo
  branch            = var.policy_branch
  path              = "bundles/aws/baseline"
}

# 4. Hard Mandatory Azure Baseline Policy Set
resource "terrakube_policy_set" "azure_baseline" {
  organization_id   = var.organization_id
  name              = "azure-security-baseline"
  description       = "Hard mandatory guardrail enforcing storage HTTPS/TLS 1.2 and blocking open inbound NSG admin ports"
  enforcement_level = "hard_mandatory"
  vcs_id            = var.vcs_id
  repository        = var.policy_repo
  branch            = var.policy_branch
  path              = "bundles/azure/baseline"
}

# 5. Hard Mandatory GCP Baseline Policy Set
resource "terrakube_policy_set" "gcp_baseline" {
  organization_id   = var.organization_id
  name              = "gcp-security-baseline"
  description       = "Hard mandatory guardrail enforcing storage uniform bucket access and disallowing public compute IPs"
  enforcement_level = "hard_mandatory"
  vcs_id            = var.vcs_id
  repository        = var.policy_repo
  branch            = var.policy_branch
  path              = "bundles/gcp/baseline"
}
