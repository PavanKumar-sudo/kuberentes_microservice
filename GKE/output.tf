output "gke_cluster_name" {
  value = module.kubernetes-engine.name
}

output "cluster_id" {
  value = module.kubernetes-engine.cluster_id
}
