# Reference 
# https://developer.hashicorp.com/terraform/tutorials/kubernetes/gke
# https://registry.terraform.io/providers/hashicorp/google/latest/docs#example-usage
# https://github.com/hashicorp/learn-terraform-provision-gke-cluster

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.27.0"
    }
  }

  required_version = ">= 0.14"
}

