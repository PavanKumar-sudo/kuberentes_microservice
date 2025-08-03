variable "region" {
  description = "The AWS region to deploy resources into (e.g., us-east-1)"
  type        = string
}

variable "vpc_name" {
  description = "The name for the VPC and related resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC (e.g., 10.0.0.0/16)"
  type        = string
  validation {
    condition     = can(regex("^(\\d+\\.\\d+\\.\\d+\\.\\d+/\\d+)$", var.vpc_cidr))
    error_message = "CIDR block must be in valid format, e.g. 10.0.0.0/16"
  }
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for internet access from private subnets"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway to reduce cost"
  type        = bool
  default     = true
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "k8s_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.29"
}

variable "enable_public_access" {
  description = "Whether the EKS API is publicly accessible"
  type        = bool
  default     = true
}

variable "instance_types" {
  description = "List of EC2 instance types for worker nodes"
  type        = list(string)
}

variable "capacity_type" {
  description = "Capacity type for node group: ON_DEMAND or SPOT"
  type        = string
  default     = "ON_DEMAND"
}

variable "node_desired" {
  description = "Desired number of worker nodes"
  type        = number
}

variable "node_min" {
  description = "Minimum number of worker nodes"
  type        = number
}

variable "node_max" {
  description = "Maximum number of worker nodes"
  type        = number
}

variable "tags" {
  description = "Map of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
