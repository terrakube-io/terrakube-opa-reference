terraform {
  required_version = ">= 1.5.0"
  required_providers {
    terrakube = {
      source  = "terrakube-io/terrakube"
      version = "~> 0.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

provider "terrakube" {
  endpoint = var.terrakube_api_url
  token    = var.terrakube_pat
}

# Resolve target organization information
data "terrakube_organization" "org" {
  name = var.organization_name
}
