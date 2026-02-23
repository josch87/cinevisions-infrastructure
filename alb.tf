resource "aws_lb" "webserver" {
  name                       = "${local.name_prefix}-webserver-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb.id]
  subnets                    = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  enable_deletion_protection = false

  tags = {
    Name = "${local.name_prefix}-webserver-lb"
  }
}

