variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region for the instance"
  type        = string
  default     = "us-west1"
}

variable "vpc_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet in the VPC"
  type        = string
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
