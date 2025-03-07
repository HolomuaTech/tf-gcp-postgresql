resource "google_sql_database_instance" "postgres_instance" {
  name                = var.instance_name
  database_version    = var.postgres_version
  region              = var.region
  project             = var.project_id
  deletion_protection = var.deletion_protection

  settings {
    tier      = var.instance_size
    disk_size = var.disk_size
    edition   = var.edition

    # Enable IAM authentication if requested
    dynamic "database_flags" {
      for_each = var.enable_iam_auth ? [1] : []
      content {
        name  = "cloudsql.iam_authentication"
        value = "on"
      }
    }

    ip_configuration {
      ipv4_enabled = true

      dynamic "authorized_networks" {
        for_each = var.authorized_networks
        content {
          name  = authorized_networks.value.name
          value = authorized_networks.value.value
        }
      }
    }
    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
    }
  }
}

# Set the password for the 'postgres' user
resource "google_sql_user" "postgres_root_user" {
  name     = "postgres"
  instance = google_sql_database_instance.postgres_instance.name
  project  = var.project_id
  password = random_password.postgres_root_password.result
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

# Generate a random password for the root user
resource "random_password" "postgres_root_password" {
  length           = 16
  special          = true
  override_special = "!@#$%^&*()-_=+[]{}<>:;,.?"
}

# Create a DNS record for the PostgreSQL instance
resource "google_dns_record_set" "postgres_dns_record" {
  project      = var.dns_project_id
  managed_zone = var.dns_zone_name
  name         = "${var.cname_subdomain}-db.${var.dns_name}."
  type         = "A"
  ttl          = 300
  rrdatas      = [google_sql_database_instance.postgres_instance.public_ip_address]

  depends_on = [google_sql_database_instance.postgres_instance]
}

# End of file - no outputs here

