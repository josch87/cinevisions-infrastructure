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
  vpc_security_group_ids = [aws_security_group.webserver_sg.id, aws_security_group.ssh_sg.id]
  key_name               = var.key_name
  iam_instance_profile   = var.iam_instance_profile_webserver

  user_data = templatefile("configure-webserver.sh.tftpl", {
    environment = var.environment
    rds_host    = split(":", aws_db_instance.mariadb_rds.endpoint)[0]
    db_username = aws_db_instance.mariadb_rds.username
  })
  user_data_replace_on_change = true

  tags = {
    Name        = "cinevisions-web-server"
    Environment = var.environment
  }
}