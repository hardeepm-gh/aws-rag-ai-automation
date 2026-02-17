output "public_ip" {
  description = "The public IP address of the web server"
  value       = aws_instance.this.public_ip
}
output "security_group_id" {
  description = "The ID of the security group assigned to the web server"
  value       = aws_security_group.web_sg.id
}