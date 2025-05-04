# modules/alb/variables.tf - Add these new variables

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "security_group_id" {
  description = "ID of the security group"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the target group"
  type        = string
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
}

# Add these new variables for cost optimization
variable "enable_logs" {
  description = "Enable access logs for ALB"
  type        = bool
  default     = false
}

variable "enable_waf" {
  description = "Enable WAF for ALB"
  type        = bool
  default     = false
}