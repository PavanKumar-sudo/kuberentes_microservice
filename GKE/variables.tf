variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "The region to deploy the GKE cluster"
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "subnet_cidr" {
  description = "The CIDR range for the subnet"
  type        = string
}

variable "pod_range_name" {
  description = "The name of the secondary range for pods"
  type        = string
}

variable "pod_cidr" {
  description = "The CIDR range for pods"
  type        = string
}

variable "service_range_name" {
  description = "The name of the secondary range for services"
  type        = string
}

variable "service_cidr" {
  description = "The CIDR range for services"
  type        = string
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the GKE cluster"
  type        = string
}

variable "enable_private_endpoint" {
  description = "Whether to enable private endpoint for the GKE cluster"
  type        = bool
}

variable "master_cidr" {
  description = "The CIDR block for the GKE master"
  type        = string
}

variable "node_pool_name" {
  description = "The name of the node pool"
  type        = string
}

variable "machine_type" {
  description = "The machine type for the node pool"
  type        = string
}

variable "min_node_count" {
  description = "Minimum number of nodes in the node pool"
  type        = number
}

variable "max_node_count" {
  description = "Maximum number of nodes in the node pool"
  type        = number
}

variable "disk_size_gb" {
  description = "Disk size for nodes in GB"
  type        = number
}

variable "service_account_email" {
  description = "Service account email for the node pool"
  type        = string
}

variable "admin_user" {
  description = "The admin user for GKE access"
  type        = string
}