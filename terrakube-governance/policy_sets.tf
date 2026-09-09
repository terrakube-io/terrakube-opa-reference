# 1. Advisory Tagging Policy Set
resource "terrakube_policy_set" "common_tagging" {
  organization_id   = data.terrakube_organization.org.id
  name              = "common-mandatory-tagging"
  description       = "Advisory guardrail requiring Environment, Owner, and CostCenter tags on all cloud resources"
  enforcement_level = "advisory"
  vcs_id            = var.vcs_id
  repository        = var.policy_repo
  branch            = var.policy_branch
  folder            = "bundles/common/tagging"
}

# 2. Soft Mandatory Blast Radius Policy Set
resource "terrakube_policy_set" "blast_radius" {
  organization_id   = data.terrakube_organization.org.id
  name              = "common-blast-radius"
  description       = "Soft mandatory guardrail requiring SecOps override approval if deletions exceed safe thresholds"
  enforcement_level = "soft_mandatory"
  vcs_id            = var.vcs_id
  repository        = var.policy_repo
  branch            = var.policy_branch
  folder            = "bundles/common/blast_radius"
}

# 3. Hard Mandatory AWS Baseline Policy Set
resource "terrakube_policy_set" "aws_baseline" {
  organization_id   = data.terrakube_organization.org.id
  name              = "aws-security-baseline"
  description       = "Hard mandatory guardrail enforcing S3 block public access, EBS encryption, and IMDSv2"
  enforcement_level = "hard_mandatory"
  vcs_id            = var.vcs_id
  repository        = var.policy_repo
  branch            = var.policy_branch
  folder            = "bundles/aws/baseline"
}

# 4. Hard Mandatory Azure Baseline Policy Set
resource "terrakube_policy_set" "azure_baseline" {
  organization_id   = data.terrakube_organization.org.id
  name              = "azure-security-baseline"
  description       = "Hard mandatory guardrail enforcing storage HTTPS/TLS 1.2 and blocking open inbound NSG admin ports"
  enforcement_level = "hard_mandatory"
  vcs_id            = var.vcs_id
  repository        = var.policy_repo
  branch            = var.policy_branch
  folder            = "bundles/azure/baseline"
}

# 5. Hard Mandatory GCP Baseline Policy Set
resource "terrakube_policy_set" "gcp_baseline" {
  organization_id   = data.terrakube_organization.org.id
  name              = "gcp-security-baseline"
  description       = "Hard mandatory guardrail enforcing storage uniform bucket access and disallowing public compute IPs"
  enforcement_level = "hard_mandatory"
  vcs_id            = var.vcs_id
  repository        = var.policy_repo
  branch            = var.policy_branch
  folder            = "bundles/gcp/baseline"
}

# 6. Advisory Password Length Policy Set
resource "terrakube_policy_set" "password_advisory" {
  organization_id   = data.terrakube_organization.org.id
  name              = "password-length-advisory"
  description       = "Advisory guardrail recommending password length >= 16 characters"
  enforcement_level = "advisory"
  vcs_id            = var.vcs_id
  repository        = var.policy_repo
  branch            = var.policy_branch
  folder            = "bundles/password/advisory"
}

# 7. Soft Mandatory Password Length Policy Set
resource "terrakube_policy_set" "password_soft_mandatory" {
  organization_id   = data.terrakube_organization.org.id
  name              = "password-length-soft-mandatory"
  description       = "Soft mandatory guardrail requiring SecOps override if password length is between 8 and 11 characters"
  enforcement_level = "soft_mandatory"
  override_team     = var.override_team
  vcs_id            = var.vcs_id
  repository        = var.policy_repo
  branch            = var.policy_branch
  folder            = "bundles/password/soft_mandatory"
}

# 8. Hard Mandatory Password Length Policy Set
resource "terrakube_policy_set" "password_hard_mandatory" {
  organization_id   = data.terrakube_organization.org.id
  name              = "password-length-hard-mandatory"
  description       = "Hard mandatory guardrail blocking apply if password length is less than 8 characters"
  enforcement_level = "hard_mandatory"
  vcs_id            = var.vcs_id
  repository        = var.policy_repo
  branch            = var.policy_branch
  folder            = "bundles/password/hard_mandatory"
}
