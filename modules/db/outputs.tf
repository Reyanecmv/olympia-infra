output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.postgres.address
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.postgres.endpoint
}

output "password_secret_arn" {
  description = "ARN of the secret containing the database password"
  value       = "${aws_secretsmanager_secret.db_password.arn}:password::"
}