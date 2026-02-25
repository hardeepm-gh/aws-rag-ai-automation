data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}
resource "aws_launch_template" "this" {
  name_prefix   = "${var.env}-tpl-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [var.web_sg_id]

  # Ensure user_data starts here and ends with EOF
  user_data = base64encode(<<-EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Success! Day 28 Live</h1><p>DB Endpoint: ${var.db_endpoint}</p>" > /var/www/html/index.html
EOF
  )
}

# network_interfaces {
# associate_public_ip_address = true
# security_groups             = [var.web_sg_id]
# }

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
