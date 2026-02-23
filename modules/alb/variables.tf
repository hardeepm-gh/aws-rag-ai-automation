variable "env" { type = string }
variable "vpc_id" { type = string }
variable "alb_sg_id" { type = string }
variable "public_subnets" { # Rename this from public_subnet_ids
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}