#############################################
# 💠 General Settings
#############################################

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "prefix" {
  type = string
}

variable "tags" {
  type = map(string)
}


#############################################
# ☁️ Networking Settings
#############################################

variable "vnet_name" {
  type = string
}

variable "vnet_cidr" {
  type = string
}

variable "aks_subnet_name" {
  type    = string
  default = "" # Optional, can be set to a custom name
}


variable "aks_subnet_cidr" {
  type = string
}


variable "network_plugin" {
  type = string
}

variable "load_balancer_sku" {
  type = string
}

variable "service_cidr" {
  type = string
}

variable "dns_service_ip" {
  type = string
}

variable "docker_bridge_cidr" {
  type = string
}


#############################################
# ☸️ AKS Cluster Settings
#############################################

variable "cluster_name" {
  type = string
}

variable "k8s_version" {
  type = string
}

variable "sku_tier" {
  type = string
}

variable "cluster_log_analytics_workspace_name" {
  type = string
}

variable "availability_zones" {
  type    = list(string)
  default = null # Optional, can be set to a list of availability zones
}

variable "upgrade_channel" {
  type    = string
  default = "" # Optional, can be set to a specific upgrade channel
}

variable "node_os_upgrade_channel" {
  type    = string
  default = "" # Optional, can be set to a specific node OS upgrade channel
}


#############################################
# 🧱 Node Pool Settings
#############################################


variable "system_node_pool_name" {
  type = string
}
variable "system_vm_size" {
  type = string
}
variable "system_os_disk_size_gb" {
  type = number
}
variable "system_os_sku" {
  type = string
}
variable "system_node_count" {
  type = number
}
variable "system_max_pods" {
  type = number
}
variable "system_az_zones" {
  type    = list(string)
  default = null # Optional, can be set to a list of availability zones
}
variable "system_node_labels" {
  type    = map(string)
  default = {} # Optional, can be set to custom labels
}
variable "system_node_taints" {
  type    = list(string)
  default = [] # Optional, can be set to custom taints
}
variable "user_node_pool_name" {
  type = string
}
variable "user_vm_size" {
  type = string
}
variable "user_os_disk_size_gb" {
  type = number
}
variable "user_os_sku" {
  type = string
}
variable "user_enable_auto_scaling" {
  type    = bool
  default = false # Optional, can be set to true for auto-scaling
}
variable "user_min_count" {
  type    = number
  default = 1 # Optional, can be set to a custom minimum count
}
variable "user_max_count" {
  type    = number
  default = 3 # Optional, can be set to a custom maximum count
}
variable "user_max_pods" {
  type    = number
  default = 110 # Optional, can be set to a custom maximum pods per user node
}
variable "user_az_zones" {
  type    = list(string)
  default = ["1", "2", "3"] # Optional, can be set to a list of availability zones
}
variable "user_node_labels" {
  type    = map(string)
  default = {} # Optional, can be set to custom labels
}
variable "user_node_taints" {
  type    = list(string)
  default = [] # Optional, can be set to custom taints
}



#############################################
# 🔐 Identity & RBAC Settings
#############################################

variable "tenant_id" {
  type = string
}

variable "admin_group_object_ids" {
  type = list(string)
}
