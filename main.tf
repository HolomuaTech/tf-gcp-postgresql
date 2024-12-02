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
      ipv4_enabled = true
    }
  }
}

# Create the primary PostgreSQL database
resource "google_sql_database" "postgres_database" {
  name     = var.database_name
  instance = google_sql_database_instance.postgres_instance.name
  project  = var.project_id

  # Ensure the database is created after the instance
  depends_on = [google_sql_database_instance.postgres_instance]
}

# Store root (postgres) user password in Google Secret Manager
resource "google_secret_manager_secret" "postgres_root_secret" {
  secret_id = "${var.instance_name}-postgres-root-password"
  project   = var.project_id

  replication {
    auto {}
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
    auto {}
  }
}

# Add a secret version with the connection details in JSON format
resource "google_secret_manager_secret_version" "postgres_db_secret_version" {
  secret = google_secret_manager_secret.postgres_db_secret.id
  secret_data = jsonencode({
    username = "postgres"
    password = random_password.postgres_root_password.result
    hostname = "${var.cname_subdomain}-db.${var.dns_name}"
    database = var.database_name
    port     = "5432"
  })
}

# Generate a random password for the root user
resource "random_password" "postgres_root_password" {
  length  = 16
  special = true
}

# Create a DNS record for the PostgreSQL instance
resource "google_dns_record_set" "postgres_dns_record" {
  managed_zone = var.dns_zone_name
  name         = "${var.cname_subdomain}-db.${var.dns_name}."
  type         = "A"
  ttl          = 300
  rrdatas      = [google_sql_database_instance.postgres_instance.public_ip_address]

  depends_on = [google_sql_database_instance.postgres_instance]
}

