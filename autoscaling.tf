data "aws_default_tags" "default_tags" {}

resource "aws_launch_template" "webserver" {
  name = "${local.name_prefix}-webserver-lt"

  image_id               = data.aws_ami.amazon-linux_2023.id
  instance_type          = var.webserver_instance_type
  key_name               = var.key_name

  depends_on             = [aws_db_instance.mariadb, data.aws_ssm_parameter.wp_password]

  iam_instance_profile {
    name = data.aws_iam_instance_profile.webserver.name
  }

  vpc_security_group_ids = [aws_security_group.webserver.id]

  user_data = base64encode(templatefile("configure-webserver.sh.tftpl", {
    project_name = var.project_name
    environment  = var.environment
    rds_host     = split(":", aws_db_instance.mariadb.endpoint)[0]
    db_username  = aws_db_instance.mariadb.username
  }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${local.name_prefix}-webserver"
    }
  }

  tags = {
    Name = "${local.name_prefix}-webserver-lt"
  }
}

resource "aws_autoscaling_group" "webserver" {
  name     = "${local.name_prefix}-webserver-asg"
  min_size = 1
  max_size = 4

  vpc_zone_identifier = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  launch_template {
    id = aws_launch_template.webserver.id
  }

  # Restricted in the Sandbox – no identity-based policy allows the autoscaling:CreateOrUpdateTags action
  # dynamic "tag" {
  #   for_each = data.aws_default_tags.default_tags.tags
  #   content {
  #     key                 = tag.key
  #     value               = tag.value
  #     propagate_at_launch = true
  #   }
  # }

  # tag {
  #   key                 = "Name"
  #   value               = "${local.name_prefix}-webserver-asg"
  #   propagate_at_launch = false
  # }
}