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
  allocated_storage          = 10
  db_name                    = "cinevisions"
  engine                     = "mariadb"
  engine_version             = "11.8"
  auto_minor_version_upgrade = true
  instance_class             = "db.t3.micro"
  username                   = "rds_master"
  password                   = data.aws_ssm_parameter.rds_master_password.value
  skip_final_snapshot        = true
  multi_az                   = true
  db_subnet_group_name       = aws_db_subnet_group.rds_subnet_group.name

  tags = {
    Name        = "Cinevisions MariaDB-RDS Instance"
    Environment = var.environment
  }
}
