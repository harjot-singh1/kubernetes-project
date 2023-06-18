# Reference 
# https://developer.hashicorp.com/terraform/tutorials/kubernetes/gke
# https://registry.terraform.io/providers/hashicorp/google/latest/docs#example-usage
# https://github.com/hashicorp/learn-terraform-provision-gke-cluster


output "region" {
  value       = var.region
  description = "GCloud Region"
}

output "project_id" {
  value       = var.project_id
  description = "GCloud Project ID"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {
  value       = google_container_cluster.primary.endpoint
  description = "GKE Cluster Host"
}

output "filestore_ip" {
    value = google_filestore_instance.primary.name
}
