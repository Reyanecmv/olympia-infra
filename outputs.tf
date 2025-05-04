output "alb_dns_name" {
  description = "DNS name of the load balancer"
  value       = module.alb.dns_name
}

output "db_endpoint" {
  description = "The endpoint of the PostgreSQL database"
  value       = module.db.db_instance_address
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket for images"
  value       = module.s3.bucket_name
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecs.repository_url
}