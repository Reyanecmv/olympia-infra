variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "instance_class" {
  description = "Instance class for the database"
  type        = string
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "username" {
  description = "Username for the database"
  type        = string
}

variable "password_secret_name" {
  description = "Name of the secret for the database password"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "security_group_id" {
  description = "ID of the security group"
  type        = string
}