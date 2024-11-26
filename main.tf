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
  name          = "${var.instance_name}-private-ip-range"
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
  name                = var.instance_name
  database_version    = var.postgres_version
  region              = var.region
  project             = var.project_id
  deletion_protection = var.deletion_protection

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

# Create the primary PostgreSQL database
resource "google_sql_database" "postgres_database" {
  name     = var.database_name
  instance = google_sql_database_instance.postgres_instance.name
  project  = var.project_id
}

# Store root (postgres) user password in Google Secret Manager
resource "google_secret_manager_secret" "postgres_root_secret" {
  secret_id = "${var.instance_name}-postgres-root-password"
  project   = var.project_id
  replication {
    automatic = true
  }
}

# Add a secret version with the root password
resource "google_secret_manager_secret_version" "postgres_root_secret_version" {
  secret      = google_secret_manager_secret.postgres_root_secret.id
  secret_data = random_password.postgres_root_password.result
}

# Store database connection details in Google Secret Manager
resource "google_secret_manager_secret" "postgres_db_secret" {
  secret_id = "${var.instance_name}-db-connection"
  project   = var.project_id
  replication {
    automatic = true
  }
}

# Add a secret version with the connection details in JSON format
resource "google_secret_manager_secret_version" "postgres_db_secret_version" {
  secret = google_secret_manager_secret.postgres_db_secret.id
  secret_data = jsonencode({
    username   = "postgres"
    password   = random_password.postgres_root_password.result
    hostname   = google_sql_database_instance.postgres_instance.connection_name
    database   = var.database_name
    port       = "5432"
  })
}

# Generate a random password for the root user
resource "random_password" "postgres_root_password" {
  length  = 16
  special = true
}

