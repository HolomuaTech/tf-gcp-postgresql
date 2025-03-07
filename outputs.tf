output "postgres_connection_name" {
  description = "The connection name of the PostgreSQL instance."
  value       = google_sql_database_instance.postgres_instance.connection_name
}

# PostgreSQL Database Details
output "postgres_database_name" {
  description = "The name of the primary PostgreSQL database."
  value       = google_sql_database.postgres_database.name
}

output "postgres_root_secret_name" {
  description = "The Secret Manager secret storing the root user password."
  value       = "projects/${var.project_id}/secrets/${google_secret_manager_secret.postgres_root_secret.secret_id}"
}

output "postgres_dns_name" {
  description = "The DNS name for the PostgreSQL instance."
  value       = "${var.cname_subdomain}-db.${var.dns_name}"
}

output "instance_name" {
  description = "The name of the PostgreSQL instance"
  value       = google_sql_database_instance.postgres_instance.name
}

output "instance_ip" {
  description = "The public IP address of the PostgreSQL instance"
  value       = google_sql_database_instance.postgres_instance.public_ip_address
}

output "iam_authentication_enabled" {
  description = "Whether IAM authentication is enabled for the instance"
  value       = var.enable_iam_auth
}

