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

resource "aws_lb_target_group" "webserver_tg" {
  name        = "${local.name_prefix}-webserver-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  tags = {
    Name = "${local.name_prefix}-webserver-tg"
  }
}

resource "aws_lb_listener" "webserver_http" {
  load_balancer_arn = aws_lb.webserver.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.webserver_tg.arn
  }

  tags = {
    Name = "${local.name_prefix}-webserver-http-listener"
  }
}