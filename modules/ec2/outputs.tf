output "instance_id" {
  value = aws_instance.this.id
}

output "public_ip" {
  value = aws_instance.this.public_ip
}

# This allows the DB to see which security group is allowed to connect to it
output "security_group_id" {
  value = var.security_group_id
}