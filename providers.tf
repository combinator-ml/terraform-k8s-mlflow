terraform {
  required_providers {
    helm = {
      version = ">= 2.0.0"
      source  = "hashicorp/helm"
    }
    kubernetes = {
      version = ">= 2.0.0"
      source  = "hashicorp/kubernetes"
    }
  }
  required_version = ">= 0.14"
}
