resource "aws_lb" "app_lb" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sgmain.id]
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]



  enable_deletion_protection = false
  idle_timeout               = 60

  tags = {
    Name = var.lb_name
  }
}

resource "aws_lb_target_group" "app_tg" {
  name        = var.target_group_name
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  vpc_id      = aws_vpc.vpcmain.id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = "30"
    timeout             = "5"
    healthy_threshold   = "2"
    unhealthy_threshold = "2"
  }

  tags = {
    Name = "${var.lb_name}-tg"
  }
}

resource "aws_lb_target_group_attachment" "app_attachment" {
  count            = 2
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.vmmain[count.index].id
  port             = var.target_group_port
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = "arn:aws:acm:ap-south-1:431579357115:certificate/7b41b88e-a900-4161-9b28-7caed1300077"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}





