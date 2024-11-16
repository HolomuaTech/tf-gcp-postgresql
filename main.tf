data "google_compute_network" "vpc" {
  name    = var.vpc_name
  project = var.project_id
}

data "google_compute_subnetwork" "subnet" {
  name    = var.subnet_name
  region  = var.region
  project = var.project_id
}

resource "google_sql_database_instance" "postgres_instance" {
  name             = var.instance_name
  database_version = var.postgres_version
  region           = var.region
  project          = var.project_id

  settings {
    tier      = var.instance_size
    disk_size = var.disk_size
    disk_type = "PD_SSD"
    ip_configuration {
      ipv4_enabled    = false
      private_network = data.google_compute_network.vpc.self_link
    }
  }
}

