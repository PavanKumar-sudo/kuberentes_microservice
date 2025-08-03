# Get Availability Zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Define an IAM Role for EKS administrators
resource "aws_iam_role" "eks_admin_role" {
  name = "${var.cluster_name}-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::535002879757:user/Handspavan"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

# Attach required policies to the admin role
resource "aws_iam_role_policy_attachment" "eks_admin_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_admin_role.name
}

resource "aws_iam_role_policy_attachment" "eks_readonly_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSDashboardConsoleReadOnly"
  role       = aws_iam_role.eks_admin_role.name
}

# Create VPC using terraform-aws-modules/vpc
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.4.0"

  name            = var.vpc_name
  cidr            = var.vpc_cidr
  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.tags
}

# Create EKS cluster using terraform-aws-modules/eks
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = var.cluster_name
  cluster_version = var.k8s_version
  subnet_ids      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  cluster_endpoint_public_access = var.enable_public_access

  eks_managed_node_group_defaults = {
    instance_types = var.instance_types
    capacity_type  = var.capacity_type
  }

  eks_managed_node_groups = {
    default = {
      desired_size   = var.node_desired
      min_size       = var.node_min
      max_size       = var.node_max
      instance_types = var.instance_types
      capacity_type  = var.capacity_type
    }
  }

  enable_cluster_creator_admin_permissions = true

  access_entries = {
    eks_admin = {
      principal_arn     = aws_iam_role.eks_admin_role.arn
      kubernetes_groups = ["eks-admins"] # Valid custom group (optional)
    }
  }

  tags = var.tags
}
