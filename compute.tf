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

data "aws_iam_instance_profile" "webserver" {
  name = var.iam_instance_profile_webserver
}

resource "aws_instance" "bastion_host" {
  ami                    = data.aws_ami.amazon-linux_2023.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.ssh.id]
  key_name               = var.key_name
  iam_instance_profile   = data.aws_iam_instance_profile.webserver.name

  tags = {
    Name = "${local.name_prefix}-bastion-host"
  }
}