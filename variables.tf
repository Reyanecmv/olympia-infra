variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-central-1" # Frankfurt (closest to Eastern Europe)
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "parking-management"
}

variable "default_tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default     = {
    Environment = "production"
    Project     = "parking-management"
    ManagedBy   = "terraform"
  }
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "parkingapp"
}

variable "db_username" {
  description = "Username for the database"
  type        = string
  default     = "parkingadmin"
  sensitive   = true
}

variable "db_instance_class" {
  description = "Instance class for the database"
  type        = string
  default     = "db.t3.micro"
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 3000
}

variable "container_cpu" {
  description = "CPU units for the container"
  type        = number
  default     = 256 # 1 vCPU
}

variable "container_memory" {
  description = "Memory for the container"
  type        = number
  default     = 512 # 2 GB
}

variable "app_count" {
  description = "Number of containers to run"
  type        = number
  default     = 1
}

variable "app_domain" {
  description = "Domain name for the application"
  type        = string
  default     = "parking.example.com" # Change this to your actual domain
}