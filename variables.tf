variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region for the instance"
  type        = string
  default     = "us-west1"
}

variable "instance_name" {
  description = "Cloud SQL instance name"
  type        = string
  default     = "doe-demo-db"
}

variable "postgres_version" {
  description = "PostgreSQL version to use"
  type        = string
  default     = "POSTGRES_14"
}

variable "instance_size" {
  description = "Machine type for the instance"
  type        = string
  default     = "db-f1-micro"
}

variable "disk_size" {
  description = "Size of the disk in GB"
  type        = number
  default     = 10
}

variable "deletion_protection" {
  description = "Enable or disable deletion protection for the database instance"
  type        = bool
  default     = true
}

variable "database_name" {
  description = "The name of the PostgreSQL database to be created."
  type        = string
}

variable "dns_zone_name" {
  description = "Name of the managed DNS zone for the database."
  type        = string
}

variable "dns_name" {
  description = "Base domain name for DNS entries (e.g., example.com)."
  type        = string
}

variable "cname_subdomain" {
  description = "Subdomain for the PostgreSQL database DNS entry."
  type        = string
}

