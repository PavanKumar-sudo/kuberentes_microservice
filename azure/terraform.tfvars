resource_group_name = "rg-aks-pavan"
location            = "eastus"

vnet_name           = "vnet-aks"

vnet_cidr           = "10.0.0.0/16"
aks_subnet_cidr     = "10.0.1.0/24"
aks_subnet_name     = "aks-SUBNET3" # Optional, can be set to a custom name
cluster_name        = "aks-cluster-pavan"
k8s_version         = "1.32.5"



# ✅ Use availability zones for high availability
availability_zones = ["1", "2"] # Optional, can be set to a list of availability zones

# Optional: Upgrade channels for auto-upgrade
upgrade_channel     = "patch" # Optional, can be set to a specific upgrade channel
node_os_upgrade_channel = "NodeImage"

# Node Pool Config
system_node_pool_name = "systempool"
system_vm_size        = "Standard_B2s" # Lower cost VM
system_os_disk_size_gb = 30
system_os_sku         = "Ubuntu" # Use Ubuntu for lower cost
system_node_count    = 1 # Single node for testing
system_max_pods      = 30 # Default max pods
system_az_zones     = ["1"] # Use zone 1 for testing
system_node_labels = {
  "role" = "system"  # ✅ safe, custom key
}

system_node_taints = ["CriticalAddonsOnly=true:NoSchedule"] # Default taint for system nodes
# User Node Pool Config
user_node_pool_name = "userpool"
user_vm_size        = "Standard_B2s" # Lower cost VM
user_os_disk_size_gb = 30
user_os_sku         = "Ubuntu" # Use Ubuntu for lower cost
user_enable_auto_scaling = false # Disable auto-scaling for simplicity
user_min_count     = 1 # Minimum 1 node
user_max_count     = 3 # Maximum 3 nodes for testing
user_max_pods      = 30 # Default max pods
user_az_zones     = ["1","2","3"] # Use zone 1 for testing
# Optional: User node labels and taints
user_node_labels = {
 "role" = "user"  # ✅ Fixed
}

# ✅ Use Free tier unless premium needed
sku_tier            = "Free"

# AAD Config
tenant_id           = "50edf662-b60b-4557-9830-cfb058363f48"
admin_group_object_ids = ["fe207f21-7c1d-40c9-8ecd-2d219b0461b7"]

# ✅ Network Config
network_plugin      = "azure"
load_balancer_sku   = "standard"
# ⚠️ For testing only
service_cidr        = "10.100.0.0/16"
dns_service_ip      = "10.100.0.10"
docker_bridge_cidr  = "172.17.0.1/16"

# ✅ Optional: Turn off log analytics for now
cluster_log_analytics_workspace_name = ""

# Prefix & Tags
prefix = "aks-pavan"
tags = {
  environment   = "dev"
  owner         = "pavan"
  team          = "devops"
  support_plan  = "basic"
}
