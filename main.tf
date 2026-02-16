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