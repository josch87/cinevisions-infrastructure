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

resource "aws_instance" "webserver" {
  ami                    = data.aws_ami.amazon-linux_2023.id
  instance_type          = var.webserver_instance_type
  subnet_id              = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.webserver.id, aws_security_group.ssh.id]
  key_name               = var.key_name
  iam_instance_profile   = data.aws_iam_instance_profile.webserver.name
  depends_on             = [aws_db_instance.mariadb, data.aws_ssm_parameter.wp_password]

  user_data = templatefile("configure-webserver.sh.tftpl", {
    project_name = var.project_name
    environment  = var.environment
    rds_host     = split(":", aws_db_instance.mariadb.endpoint)[0]
    db_username  = aws_db_instance.mariadb.username
  })
  user_data_replace_on_change = var.environment == "dev"

  tags = {
    Name = "${local.name_prefix}-webserver"
  }
}