# terraform.tfvars

project_id            = "pavan-tf-project"
region                = "us-central1"

# GKE cluster
cluster_name          = "private-gke-cluster"
kubernetes_version = "1.33.2-gke.1240000" # You can update this based on supported versions

# VPC and Subnet
network_name          = "gke-vpc"
subnet_name           = "gke-subnet"
subnet_cidr           = "10.10.0.0/16"

# Secondary ranges
pod_range_name        = "gke-pod-range"
pod_cidr              = "10.20.0.0/16"

service_range_name    = "gke-service-range"
service_cidr          = "10.30.0.0/20"

# GKE Master authorized range (only for private cluster)
master_cidr           = "172.16.0.0/28"

# Enable or disable private endpoint for master
enable_private_endpoint = false

# Node pool configuration
node_pool_name        = "default-node-pool"
machine_type          = "e2-medium"
min_node_count        = 1
max_node_count        = 3
disk_size_gb          = 100
service_account_email = "gke-node-sa@pavan-tf-project.iam.gserviceaccount.com" # Replace with actual SA email

# IAM admin user for GKE access
admin_user            = "pavanvinjamuri212@gmail.com" # Replace with your actual GCP user email
