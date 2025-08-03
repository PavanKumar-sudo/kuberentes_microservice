terraform {
  required_version = ">= 1.3.0" # Terraform 1.3+ is stable for provider 6.x

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.38.0, < 7.0.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 6.38.0, < 7.0.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}
