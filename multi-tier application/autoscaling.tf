resource "aws_launch_template" "app_launch_template" {
  name_prefix   = "${var.lb_name}-lt"
  image_id      = "ami-07c88ef0bf7488110"
  instance_type = var.size
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.sgmain.id]
  }

  key_name = aws_key_pair.deployer.key_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name = "My-Auto-asg"

  vpc_zone_identifier = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  target_group_arns   = [aws_lb_target_group.app_tg.arn]

  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  health_check_type         = "ELB"
  health_check_grace_period = 500


  launch_template {
    id      = aws_launch_template.app_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "autoscalingmachine"
    propagate_at_launch = true
  }
}

