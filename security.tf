resource "aws_security_group" "webserver_sg" {
  name        = "webserver-sg"
  description = "Security group for web server"
  vpc_id      = aws_vpc.cinevisions_vpc.id

  tags = {
    Name        = "webserver-sg"
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "webserver_sg_ingress_http" {
  security_group_id = aws_security_group.webserver_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "webserver_sg_egress_all" {
  security_group_id = aws_security_group.webserver_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_security_group" "ssh_sg" {
  name        = "ssh-sg"
  description = "SSH security group for developer access"
  vpc_id      = aws_vpc.cinevisions_vpc.id

  tags = {
    Name        = "ssh-sg"
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_sg_ingress_ssh" {
  security_group_id = aws_security_group.ssh_sg.id

  cidr_ipv4   = var.my_local_public_ip
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_egress_rule" "ssh_sg_egress_all" {
  security_group_id = aws_security_group.ssh_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow traffic to RDS"
  vpc_id      = aws_vpc.cinevisions_vpc.id

  tags = {
    Name        = "rds-sg"
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds_sg_ingress_mariadb" {
  security_group_id = aws_security_group.rds_sg.id

  referenced_security_group_id = aws_security_group.webserver_sg.id
  from_port                    = 3306
  ip_protocol                  = "tcp"
  to_port                      = 3306
}

resource "aws_vpc_security_group_egress_rule" "rds_sg_egress_all" {
  security_group_id = aws_security_group.rds_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}