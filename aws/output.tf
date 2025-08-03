output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_version" {
  description = "EKS Kubernetes version"
  value       = module.eks.cluster_version
}

output "vpc_id" {
  description = "The VPC ID for the EKS cluster"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "The private subnet IDs used by EKS"
  value       = module.vpc.private_subnets
}