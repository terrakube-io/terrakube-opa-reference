variable "terrakube_api_url" {
  type        = string
  description = "Terrakube API Endpoint URL (e.g., https://terrakube-api.platform.local)"
}

variable "terrakube_pat" {
  type        = string
  sensitive   = true
  description = "Terrakube Personal Access Token (PAT) with Admin permissions"
}

variable "organization_id" {
  type        = string
  description = "The target Organization UUID in Terrakube"
}

variable "vcs_id" {
  type        = string
  description = "The VCS Connection UUID registered in the target Organization"
}

variable "policy_repo" {
  type        = string
  default     = "terrakube-io/terrakube-opa-reference"
  description = "The policy Git repository path"
}

variable "policy_branch" {
  type        = string
  default     = "main"
  description = "Target Git branch or semantic release tag (e.g., v1.0.0)"
}

variable "workspace_ids" {
  type        = list(string)
  default     = []
  description = "List of workspace UUIDs to selectively attach policy sets to"
}
