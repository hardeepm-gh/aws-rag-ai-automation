variable "env" { type = string }
variable "ami_id" { type = string }
variable "instance_type" { type = string }

# This must match what you wrote in main.tf
variable "web_sg_id" {
  description = "The security group ID for the web servers"
  type        = string
}

# This must match what you wrote in main.tf
variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ARN for the ALB target group"
  type        = string
}