variable "env" {
  description = "Environment name (e.g. dev)"
  type        = string
}

variable "alb_arn_suffix" {
  description = "The ARN suffix of the ALB for CloudWatch dimensions"
  type        = string
}

variable "target_group_arn_suffix" {
  description = "The ARN suffix of the Target Group for CloudWatch dimensions"
  type        = string
}