variable "terrakube_api_url" {
  type        = string
  description = "Terrakube API Endpoint URL (e.g., https://terrakube-api.platform.local)"
}

variable "terrakube_pat" {
  type        = string
  sensitive   = true
  description = "Terrakube Personal Access Token (PAT) with Admin permissions"
}

variable "terrakube_hostname" {
  type        = string
  default     = "terrakube-api.platform.local"
  description = "Terrakube API hostname used in CLI backend cloud {} block (e.g., terrakube-api.platform.local)"
}

variable "organization_name" {
  type        = string
  description = "The target Organization name in Terrakube (e.g., 'simple')"
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

variable "workspace_prefix" {
  type        = string
  default     = "opa-eval-"
  description = "Prefix for automatically generated test workspaces"
}

variable "iac_version" {
  type        = string
  default     = "1.5.7"
  description = "Terraform version configured for the generated workspaces"
}
