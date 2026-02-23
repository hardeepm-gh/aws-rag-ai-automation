resource "aws_launch_template" "this" {
  name_prefix   = "${var.env}-tpl-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.web_sg_id]
  }

user_data = base64encode(<<-EOF
              #!/bin/bash
              sleep 30
              dnf update -y
              dnf install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Day 26: High Availability Fixed</h1>" > /var/www/html/index.html
              EOF
  )
}


resource "aws_autoscaling_group" "this" {
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = var.public_subnets
  target_group_arns   = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.env}-web-asg"
    propagate_at_launch = true
  }
}