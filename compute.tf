resource "aws_instance" "bastion_host" {
  ami                    = data.aws_ami.amazon-linux_2023.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  key_name               = var.key_name
  iam_instance_profile   = data.aws_iam_instance_profile.webserver.name

  tags = {
    Name = "${local.name_prefix}-bastion-host"
  }
}