terraform {
  required_version = ">= 1.5.0"
  required_providers {
    terrakube = {
      source  = "terrakube-io/terrakube"
      version = "~> 0.1.0"
    }
  }
}

provider "terrakube" {
  endpoint = var.terrakube_api_url
  token    = var.terrakube_pat
}
