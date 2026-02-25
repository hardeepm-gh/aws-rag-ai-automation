output "alb_sg_id" {
  description = "The ID of the Security Group for the ALB"
  value       = aws_security_group.alb_sg.id
}

output "web_sg_id" {
  description = "The ID of the Security Group for the Web Servers"
  value       = aws_security_group.web_sg.id
}

output "db_sg_id" {
  description = "The ID of the Security Group for the Database"
  value       = aws_security_group.db_sg.id
}