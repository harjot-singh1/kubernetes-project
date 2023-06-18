# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 3
  description = "number of gke nodes"
}

variable "cluster_name" {
  default = ""
  description = "cluster_name"
}

# GKE cluster
resource "google_container_cluster" "primary" {
  name     = "${var.cluster_name}"
  location = var.region
  
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = false
  initial_node_count       = 3
  addons_config {
    gcp_filestore_csi_driver_config {
      enabled = true
    }
  }

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}

resource "google_artifact_registry_repository" "app1-repo-name" {
  provider = google-beta
  project = var.project_id
  location      = "us-central1"
  repository_id = "app1-repo"
  description   = "app1 docker repository"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository" "app2-repo-name" {
  provider = google-beta
  project = var.project_id
  location      = "us-central1"
  repository_id = "app2-repo"
  description   = "app2 docker repository"
  format        = "DOCKER"
}

# Separately Managed Node Pool
#resource "google_container_node_pool" "primary_nodes" {
#  name       = google_container_cluster.primary.name
#  location   = var.region
#  cluster    = google_container_cluster.primary.name
#  node_count = var.gke_num_nodes
#
#  node_config {
#    oauth_scopes = [
#      "https://www.googleapis.com/auth/logging.write",
#      "https://www.googleapis.com/auth/monitoring",
#    ]
#
#    labels = {
#      env = var.project_id
#    }
#
#    # preemptible  = true
#    machine_type = "n1-standard-1"
#    tags         = ["gke-node", "${var.cluster_name}"]
#    metadata = {
#      disable-legacy-endpoints = "true"
#    }
#  }
#}

#Filestore
resource "google_filestore_instance" "primary" {
  name   = "pvc-9898"
  project = var.project_id
  location = var.region
  tier   = "STANDARD"

  file_shares {
    name                   = "vol1"
    capacity_gb            = 1024
  }

  networks {
    modes = ["MODE_IPV4"]
    network = google_compute_network.vpc.name
  }
}


# # Kubernetes provider
# # The Terraform Kubernetes Provider configuration below is used as a learning reference only. 
# # It references the variables and resources provisioned in this file. 
# # We recommend you put this in another file -- so you can have a more modular configuration.
# # https://learn.hashicorp.com/terraform/kubernetes/provision-gke-cluster#optional-configure-terraform-kubernetes-provider
# # To learn how to schedule deployments and services using the provider, go here: https://learn.hashicorp.com/tutorials/terraform/kubernetes-provider.

# provider "kubernetes" {
#   load_config_file = "false"

#   host     = google_container_cluster.primary.endpoint
#   username = var.gke_username
#   password = var.gke_password

#   client_certificate     = google_container_cluster.primary.master_auth.0.client_certificate
#   client_key             = google_container_cluster.primary.master_auth.0.client_key
#   cluster_ca_certificate = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
# }

