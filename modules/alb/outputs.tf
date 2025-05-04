# --- modules/alb/outputs.tf ---
output "dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.main.dns_name
}

output "zone_id" {
  description = "Zone ID of the load balancer"
  value       = aws_lb.main.zone_id
}

output "certificate_validation_options" {
  description = "Certificate validation options"
  value       = aws_acm_certificate.cert.domain_validation_options
}