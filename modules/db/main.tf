resource "aws_secretsmanager_secret" "db_password" {
  name                    = var.password_secret_name
  recovery_window_in_days = 0 # Set to 0 for development; use 7-30 for production
}

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode({
    password = random_password.db_password.result
  })
}

resource "aws_db_subnet_group" "postgres" {
  name       = "${var.name_prefix}-postgres-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_parameter_group" "postgres" {
  name   = "${var.name_prefix}-postgres-params"
  family = "postgres14"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  parameter {
    name  = "log_statement"
    value = "ddl"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = "1000"  # Log statements taking more than 1 second
  }
}

resource "aws_db_instance" "postgres" {
  identifier             = "${var.name_prefix}-postgres"
  engine                 = "postgres"
  engine_version         = "14.7"
  instance_class         = var.instance_class
  allocated_storage      = 10  # Changed from 20
  max_allocated_storage  = 50  # Changed from 100
  storage_type           = "gp3"
  storage_encrypted      = true

  db_name                = var.db_name
  username               = var.username
  password               = random_password.db_password.result

  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.postgres.name
  parameter_group_name   = aws_db_parameter_group.postgres.name

  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "Mon:04:00-Mon:05:00"

  skip_final_snapshot     = true  # Changed from false to avoid extra snapshot costs
  final_snapshot_identifier = "${var.name_prefix}-postgres-final-snapshot"
  deletion_protection     = false  # Changed from true for development environments

  performance_insights_enabled          = false  # Changed from true
  performance_insights_retention_period = 0      # Changed from 7

  monitoring_interval    = 0  # Changed from 60
  monitoring_role_arn    = aws_iam_role.rds_monitoring_role.arn

  enabled_cloudwatch_logs_exports = []  # Changed from ["postgresql", "upgrade"]

  # Disable Multi-AZ for cost savings
  multi_az = false  # Changed from true
}

resource "aws_iam_role" "rds_monitoring_role" {
  name = "${var.name_prefix}-rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_role_policy" {
  role       = aws_iam_role.rds_monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}