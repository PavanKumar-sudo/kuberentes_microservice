# Enable necessary Google Cloud APIs
resource "google_project_service" "container_api" {
  service = "container.googleapis.com"
  disable_on_destroy = false
}

resource "google_service_account" "gke_node_sa" {
  account_id   = "gke-node-sa"
  display_name = "GKE Node Service Account"
  project      = var.project_id
}


# VPC for the GKE cluster (for private cluster configuration)
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.0"

  project_id   = var.project_id
  network_name = var.network_name
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = var.subnet_name
      subnet_ip     = var.subnet_cidr
      subnet_region = var.region
    }
  ]

  secondary_ranges = {
    "${var.subnet_name}" = [
      {
        range_name    = var.pod_range_name
        ip_cidr_range = var.pod_cidr
      },
      {
        range_name    = var.service_range_name
        ip_cidr_range = var.service_cidr
      }
    ]
  }
}

# GKE cluster using the root Google module with private cluster config
module "kubernetes-engine" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "37.0.0"

  project_id         = var.project_id
  name               = var.cluster_name
  region             = var.region
  network            = module.vpc.network_name
  subnetwork         = module.vpc.subnets_names[0]
  ip_range_pods      = var.pod_range_name
  ip_range_services  = var.service_range_name
  kubernetes_version = var.kubernetes_version
  release_channel    = "REGULAR"
  deletion_protection = false

  enable_shielded_nodes       = true
  enable_binary_authorization = true
  
  #enable_workload_identity    = true

  # private_cluster_config = {
  #   enable_private_nodes    = true
  #   enable_private_endpoint = var.enable_private_endpoint
  #   master_ipv4_cidr_block  = var.master_cidr
  # }

  node_pools = [
    {
      name            = var.node_pool_name
      machine_type    = var.machine_type
      min_count       = var.min_node_count
      max_count       = var.max_node_count
      disk_size_gb    = var.disk_size_gb
      disk_type       = "pd-balanced"
      auto_upgrade    = true
      auto_repair     = true
      preemptible     = false
      service_account = google_service_account.gke_node_sa.email
    }
  ]

  node_pools_oauth_scopes = {
    all = ["https://www.googleapis.com/auth/cloud-platform"]
  }

 network_policy = true


  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  depends_on = [google_project_service.container_api]
}

# IAM role for GKE admin access
resource "google_project_iam_member" "gke_admin" {
  project = var.project_id
  role    = "roles/container.admin"
  member  = "user:${var.admin_user}"
}
