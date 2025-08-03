# Core AKS cluster inputs
variable "resource_group_name" {
  type        = string
  description = "Name of the Azure Resource Group"
}

variable "location" {
  type        = string
  description = "Azure region for deployment"
}

variable "cluster_name" {
  type        = string
  description = "Name of the AKS cluster"
}

variable "k8s_version" {
  type        = string
  description = "Kubernetes version to deploy"
}

variable "sku_tier" {
  type        = string
  default     = "Free"
  description = "AKS pricing tier (Free or Premium)"
}

variable "upgrade_channel" {
  type        = string
  default     = null
  description = "Kubernetes control plane upgrade channel"
}

variable "node_os_upgrade_channel" {
  type        = string
  default     = null
  description = "Node OS upgrade channel"
}

variable "admin_group_object_ids" {
  type        = list(string)
  description = "List of AAD Group Object IDs for cluster admins"
}

variable "tenant_id" {
  type        = string
  description = "Azure tenant ID for AAD integration"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to AKS resources"
}

# Networking
variable "vnet_name" {
  type        = string
  description = "Virtual Network name"
}

variable "vnet_cidr" {
  type        = string
  description = "CIDR block for the VNet"
}

variable "aks_subnet_name" {
  type        = string
  default     = "aks-subnet"
  description = "Subnet name for AKS nodes"
}

variable "aks_subnet_cidr" {
  type        = string
  description = "CIDR block for the AKS subnet"
}

variable "network_plugin" {
  type        = string
  default     = "azure"
  description = "Network plugin to use (azure, kubenet)"
}

variable "load_balancer_sku" {
  type        = string
  default     = "standard"
  description = "Load balancer SKU (standard/basic)"
}

variable "service_cidr" {
  type        = string
  description = "Service CIDR block for Kubernetes internal services"
}

variable "dns_service_ip" {
  type        = string
  description = "DNS IP address within the service CIDR"
}

variable "docker_bridge_cidr" {
  type        = string
  description = "CIDR for the Docker bridge network"
}

variable "cluster_log_analytics_workspace_name" {
  type        = string
  description = "Log Analytics Workspace name"
}

variable "prefix" {
  type        = string
  description = "Prefix for naming resources"
}

variable "availability_zones" {
  type        = list(string)
  default     = null
  description = "Availability Zones for control plane or default pool"
}

# Default Node Pool (used if you define only one pool)


# --------------------------
# SYSTEM NODE POOL Variables
# --------------------------
variable "system_node_pool_name" {
  type        = string
  description = "Name for the system node pool"
}

variable "system_vm_size" {
  type        = string
  description = "VM size for the system node pool"
}

variable "system_os_disk_size_gb" {
  type        = number
  description = "OS disk size in GB for system nodes"
}

variable "system_os_sku" {
  type        = string
  description = "OS SKU (Ubuntu, AzureLinux, etc.)"
}

variable "system_node_count" {
  type        = number
  description = "Number of nodes in the system node pool"
}

variable "system_max_pods" {
  type        = number
  default     = 30
  description = "Maximum pods per system node"
}

variable "system_az_zones" {
  type        = list(string)
  default     = ["1"]
  description = "Availability zones for system pool"
}

variable "system_node_labels" {
  type        = map(string)
  default     = {}
  description = "Labels to apply to system nodes"
}

variable "system_node_taints" {
  type        = list(string)
  default     = []
  description = "Taints to apply to system nodes"
}

# --------------------------
# USER NODE POOL Variables
# --------------------------
variable "user_node_pool_name" {
  type        = string
  description = "Name for the user node pool"
}

variable "user_vm_size" {
  type        = string
  description = "VM size for the user node pool"
}

variable "user_os_disk_size_gb" {
  type        = number
  description = "OS disk size in GB for user nodes"
}

variable "user_os_sku" {
  type        = string
  description = "OS SKU (Ubuntu, AzureLinux, etc.)"
}

variable "user_enable_auto_scaling" {
  type        = bool
  description = "Whether autoscaling is enabled for user node pool"
}

variable "user_min_count" {
  type        = number
  description = "Minimum number of nodes in user node pool"
}

variable "user_max_count" {
  type        = number
  description = "Maximum number of nodes in user node pool"
}

variable "user_max_pods" {
  type        = number
  default     = 110
  description = "Maximum pods per user node"
}

variable "user_az_zones" {
  type        = list(string)
  default     = ["1", "2", "3"]
  description = "Availability zones for user node pool"
}

variable "user_node_labels" {
  type        = map(string)
  default     = {}
  description = "Labels to apply to user nodes"
}

variable "user_node_taints" {
  type        = list(string)
  default     = []
  description = "Taints to apply to user nodes"
}
