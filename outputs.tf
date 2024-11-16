output "connection_name" {
  description = "The connection name of the PostgreSQL instance."
  value       = google_sql_database_instance.postgres_instance.connection_name
}

output "private_ip" {
  description = "The private IP address of the PostgreSQL instance."
  value       = google_sql_database_instance.postgres_instance.private_ip_address
}
