# File: aws/terraform.tfvars

region         = "us-east-1"
vpc_name       = "eks-prod-vpc"
vpc_cidr       = "10.0.0.0/16"
private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
cluster_name    = "eks-prod-cluster"
instance_types  = ["t3.medium"]
capacity_type   = "ON_DEMAND"
node_desired    = 2
node_min        = 1
node_max        = 3
enable_public_access = true
enable_nat_gateway   = true
single_nat_gateway   = true
tags = {
  Environment = "production"
  Project     = "microservices"
}