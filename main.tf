# Fetch the existing VPC
data "google_compute_network" "vpc" {
  name    = var.vpc_name
  project = var.project_id
}

# Fetch the existing Subnet
data "google_compute_subnetwork" "subnet" {
  name    = var.subnet_name
  region  = var.region
  project = var.project_id
}

# Allocate a private IP range for VPC peering
resource "google_compute_global_address" "private_ip_range" {
  name          = "google-managed-services"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = data.google_compute_network.vpc.self_link
}

# Establish the VPC peering connection
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = data.google_compute_network.vpc.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_range.name]

  depends_on = [google_compute_global_address.private_ip_range]
}

# Create the PostgreSQL database instance
resource "google_sql_database_instance" "postgres_instance" {
  name             = var.instance_name
  database_version = var.postgres_version
  region           = var.region
  project          = var.project_id

  settings {
    tier      = var.instance_size
    disk_size = var.disk_size
    ip_configuration {
      ipv4_enabled    = false
      private_network = data.google_compute_network.vpc.self_link
    }
  }

  depends_on = [google_service_networking_connection.private_vpc_connection]
}

