terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0, < 5.0.0" # Use the version that works with your module
    }
  }

  required_version = ">= 1.0.0"
}

provider "google" {
  project = var.project_id
  region  = var.region
}
