# Network information
output "postgres_connection_name" {
  description = "The connection name of the PostgreSQL instance."
  value       = google_sql_database_instance.postgres_instance.connection_name
}

output "postgres_private_ip" {
  description = "The private IP address of the PostgreSQL instance."
  value       = google_sql_database_instance.postgres_instance.private_ip_address
}

# PostgreSQL Database Details
output "postgres_database_name" {
  description = "The name of the primary PostgreSQL database."
  value       = google_sql_database.postgres_database.name
}

output "postgres_root_secret_name" {
  description = "The Secret Manager secret storing the root user password."
  value       = google_secret_manager_secret.postgres_root_secret.name
}

output "postgres_credentials" {
  description = "Connection details for the PostgreSQL instance."
  value = {
    host     = google_sql_database_instance.postgres_instance.private_ip_address
    username = "postgres"
    password = random_password.postgres_root_password.result
  }
  sensitive = true
}

# Output for the database connection secret
output "postgres_secret_name" {
  description = "The name of the Secret Manager secret storing PostgreSQL connection details."
  value       = google_secret_manager_secret.postgres_db_secret.name
}

# Postgres DNS record
output "postgres_dns_name" {
  description = "The DNS name for the PostgreSQL instance."
  value       = "${var.cname_subdomain}-db.${var.dns_name}"
}
