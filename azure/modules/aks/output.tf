output "aks_cluster_id" {
  value = azurerm_kubernetes_cluster.main.id
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.main.name
}