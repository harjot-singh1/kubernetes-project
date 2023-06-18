# Reference 
# https://developer.hashicorp.com/terraform/tutorials/kubernetes/gke
# https://registry.terraform.io/providers/hashicorp/google/latest/docs#example-usage
# https://github.com/hashicorp/learn-terraform-provision-gke-cluster

variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

provider "google" {
  project = var.project_id
  region  = "us-central1"
}

# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-subnet"
  region        = "us-central1"
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}
