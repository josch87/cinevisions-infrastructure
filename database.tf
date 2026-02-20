data "aws_ssm_parameter" "rds_master_password" {
  name            = "/cinevisions/${var.environment}/db/master_password"
  with_decryption = true
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = [aws_subnet.cinevisions_private_subnet_1.id, aws_subnet.cinevisions_private_subnet_2.id]

  tags = {
    Name        = "RDS Subnet Group"
    Environment = var.environment
  }
}

resource "aws_db_instance" "mariadb_rds" {
  identifier                 = "${local.name_prefix}-mariadb-rds"
  allocated_storage          = 10
  db_name                    = "cinevisions"
  engine                     = "mariadb"
  engine_version             = "11.8"
  auto_minor_version_upgrade = true
  instance_class             = "db.t3.micro"
  storage_type               = "gp2"
  storage_encrypted          = true
  username                   = "rds_master"
  password                   = data.aws_ssm_parameter.rds_master_password.value
  skip_final_snapshot        = var.environment != "prod"
  multi_az                   = true
  db_subnet_group_name       = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids     = [aws_security_group.rds_sg.id]
  publicly_accessible        = false
  backup_retention_period    = "prod" ? 10 : 1
  backup_window              = "03:00-04:00"

  tags = {
    Name        = "Cinevisions MariaDB-RDS Instance"
    Environment = var.environment
  }
}
