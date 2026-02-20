data "aws_ssm_parameter" "rds_master_password" {
  name            = "/cinevisions/${var.environment}/db/master_password"
  with_decryption = true
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${local.name_prefix}-rds-subnet-group"
  subnet_ids = [aws_subnet.cinevisions_private_subnet_1.id, aws_subnet.cinevisions_private_subnet_2.id]

  tags = {
    Name        = "RDS Subnet Group"
    Environment = var.environment
  }
}

resource "aws_db_instance" "mariadb_rds" {
  identifier = "${local.name_prefix}-mariadb-rds"

  # Engine configuration
  engine                     = "mariadb"
  engine_version             = "11.8"
  auto_minor_version_upgrade = true
  instance_class             = "db.t3.micro"

  # Storage configuration
  allocated_storage = 10
  storage_type      = "gp2"
  storage_encrypted = true

  # Database configuration
  db_name  = "cinevisions"
  username = "rds_master"
  password = data.aws_ssm_parameter.rds_master_password.value

  # Network configuration
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = false

  # Deletion protection
  deletion_protection = var.environment == "prod"
  skip_final_snapshot       = var.environment != "prod"
  final_snapshot_identifier = "${local.name_prefix}-mariadb-final-${formatdate("YYYYMMDDhhmm", timestamp())}"

  # High availability
  multi_az = true

  # Backup configuration
  backup_retention_period = var.environment == "prod" ? 10 : 1
  backup_window           = "03:00-04:00"
  maintenance_window      = "Sun:04:00-Sun:05:00"

  # Monitoring
  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]

  tags = {
    Name        = "Cinevisions MariaDB-RDS Instance"
    Environment = var.environment
  }
}
