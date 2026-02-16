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

