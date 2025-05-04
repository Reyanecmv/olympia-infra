# provider "aws" {
#   region = var.aws_region
#
#   default_tags {
#     tags = var.default_tags
#   }
# }

provider "aws" {
  region = var.aws_region

  # Add these lines for testing without real AWS credentials
  skip_credentials_validation = true
  skip_requesting_account_id = true
  skip_metadata_api_check     = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"

  default_tags {
    tags = var.default_tags
  }
}

# Random string for unique naming
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# 1. Update main.tf - VPC Module

module "vpc" {
  source = "./modules/vpc"

  name                = "${local.name_prefix}-vpc"
  cidr                = var.vpc_cidr
  azs                 = var.availability_zones
  private_subnets     = local.private_subnets
  public_subnets      = local.public_subnets
  enable_nat_gateway  = false  # Changed from true - disable NAT Gateway to save costs
  single_nat_gateway  = false  # Changed from true
  enable_vpn_gateway  = false
  enable_dns_hostnames = true
  enable_dns_support  = true
  enable_flow_log     = false  # Changed from true - disable flow logs to save cost
  enable_s3_endpoint  = true   # Keep S3 endpoint for access without NAT
  enable_ecr_endpoint = true   # Add ECR endpoint to allow ECS tasks to pull images without NAT
}

module "security_groups" {
  source = "./modules/security_groups"

  vpc_id          = module.vpc.vpc_id
  name_prefix     = local.name_prefix
  container_port  = var.container_port
}

module "s3" {
  source = "./modules/s3"

  bucket_name     = "${local.name_prefix}-images-${random_string.suffix.result}"
  lifecycle_days  = 365
}

module "db" {
  source = "./modules/db"

  name_prefix     = local.name_prefix
  instance_class  = var.db_instance_class
  db_name         = var.db_name
  username        = var.db_username
  password_secret_name = local.db_password_secret_name
  subnet_ids      = module.vpc.private_subnets
  security_group_id = module.security_groups.db_sg_id
}

module "ecs" {
  source = "./modules/ecs"

  name_prefix       = local.name_prefix
  container_name    = local.container_name
  container_port    = var.container_port
  container_cpu     = var.container_cpu
  container_memory  = var.container_memory
  vpc_id            = module.vpc.vpc_id
  private_subnets   = module.vpc.private_subnets
  security_group_id = module.security_groups.ecs_sg_id
  app_count         = var.app_count

  # Environment variables for the container
  container_environment = [
    { name = "NODE_ENV", value = var.environment },
    { name = "DB_HOST", value = module.db.db_instance_address },
    { name = "DB_PORT", value = "5432" },
    { name = "DB_NAME", value = var.db_name },
    { name = "DB_USER", value = var.db_username },
    { name = "S3_BUCKET", value = module.s3.bucket_name }
  ]

  # Secrets for the container
  container_secrets = [
    { name = "DB_PASSWORD", valueFrom = module.db.password_secret_arn }
  ]

  s3_bucket_arn = module.s3.bucket_arn
}

module "alb" {
  source = "./modules/alb"

  name_prefix       = "pm-${var.environment}"  # Shorter name
  vpc_id            = module.vpc.vpc_id
  public_subnets    = module.vpc.public_subnets
  security_group_id = module.security_groups.alb_sg_id
  target_group_arn  = module.ecs.target_group_arn
  container_port    = var.container_port
  domain_name       = var.app_domain
  enable_logs       = false   # Disable ALB logs
  enable_waf        = false   # Disable WAF
}