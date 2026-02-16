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
  from_port   = 0
  ip_protocol = "-1"
  to_port     = 0
}

data "aws_ami" "amazon-linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "cinevisions_web_server" {
  ami                    = data.aws_ami.amazon-linux_2023.id
  instance_type          = var.cinevisions_web_server_instance_type
  subnet_id              = aws_subnet.cinevisions_public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  key_name               = "vockey"
  user_data              = file("user-data.sh")
  tags = {
    Name        = "cinevisions-web-server"
    Environment = var.environment
  }
}