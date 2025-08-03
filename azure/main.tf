module "aks" {
  source = "./modules/aks"

  # Core settings
  resource_group_name                  = var.resource_group_name
  location                             = var.location
  cluster_name                         = var.cluster_name
  k8s_version                          = var.k8s_version
  sku_tier                             = var.sku_tier
  upgrade_channel                      = var.upgrade_channel
  node_os_upgrade_channel              = var.node_os_upgrade_channel
  admin_group_object_ids               = var.admin_group_object_ids
  tenant_id                            = var.tenant_id
  prefix                               = var.prefix
  tags                                 = var.tags

  # Networking
  vnet_name                            = var.vnet_name
  aks_subnet_name                      = var.aks_subnet_name
  vnet_cidr                            = var.vnet_cidr
  aks_subnet_cidr                      = var.aks_subnet_cidr
  network_plugin                       = var.network_plugin
  load_balancer_sku                    = var.load_balancer_sku
  service_cidr                         = var.service_cidr
  dns_service_ip                       = var.dns_service_ip
  docker_bridge_cidr                   = var.docker_bridge_cidr
  availability_zones                   = var.availability_zones

  # Log Analytics
  cluster_log_analytics_workspace_name = var.cluster_log_analytics_workspace_name

  # System Node Pool
  system_node_pool_name                = var.system_node_pool_name
  system_vm_size                       = var.system_vm_size
  system_os_disk_size_gb               = var.system_os_disk_size_gb
  system_os_sku                        = var.system_os_sku
  system_node_count                    = var.system_node_count
  system_max_pods                      = var.system_max_pods
  system_az_zones                      = var.system_az_zones
  system_node_labels                   = var.system_node_labels
  system_node_taints                   = var.system_node_taints

  # User Node Pool
  user_node_pool_name                  = var.user_node_pool_name
  user_vm_size                         = var.user_vm_size
  user_os_disk_size_gb                 = var.user_os_disk_size_gb
  user_os_sku                          = var.user_os_sku
  user_enable_auto_scaling             = var.user_enable_auto_scaling
  user_min_count                       = var.user_min_count
  user_max_count                       = var.user_max_count
  user_max_pods                        = var.user_max_pods
  user_az_zones                        = var.user_az_zones
  user_node_labels                     = var.user_node_labels
  user_node_taints                     = var.user_node_taints
}
