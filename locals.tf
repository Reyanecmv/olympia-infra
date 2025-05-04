locals {
  name_prefix = "${var.project}-${var.environment}"
  alb_name_prefix = "${var.project}-${var.environment}"

  # VPC
  private_subnets = [for k, v in var.availability_zones : cidrsubnet(var.vpc_cidr, 8, k + 1)]
  public_subnets  = [for k, v in var.availability_zones : cidrsubnet(var.vpc_cidr, 8, k + 101)]

  # Security
  db_password_secret_name = "/${local.name_prefix}/db/password"

  # App
  container_name = "parking-app"
}