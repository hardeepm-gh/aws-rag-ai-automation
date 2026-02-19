# 1. Inside resource "aws_lb" "main_alb"
resource "aws_lb" "main_alb" {
  name               = "${var.env}-main-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.security.web_sg_id]
  
  # Corrected line:
  subnets            = module.vpc.public_subnet_ids

  tags = { Name = "${var.env}-main-alb" }
}

# 2. The Target Group
resource "aws_lb_target_group" "web_tg" {
  name     = "${var.env}-web-target-group"
  port     = 80
  protocol = "HTTP"
  
  # Update: Reference the VPC module output
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# 3. The Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}