variable "project_id" {
  description = "The GCP project ID where the database will be created."
  type        = string
}

variable "region" {
  description = "The region for the Cloud SQL instance."
  type        = string
}

variable "instance_name" {
  description = "The name of the Cloud SQL instance."
  type        = string
}

variable "postgres_version" {
  description = "The PostgreSQL version for the database."
  type        = string
  default     = "POSTGRES_14"
}

variable "instance_size" {
  description = "The machine type for the Cloud SQL instance."
  type        = string
  default     = "db-f1-micro"
}

variable "disk_size" {
  description = "The disk size in GB for the database."
  type        = number
  default     = 10
}

variable "vpc_name" {
  description = "The name of the VPC network where the database will reside."
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet in the VPC."
  type        = string
}

