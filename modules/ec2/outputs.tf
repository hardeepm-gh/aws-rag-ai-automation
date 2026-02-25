output "asg_name" {
  value = aws_autoscaling_group.this.name
}
# output "web_sg_id" { value = aws_security_group.web_sg.id }
# Delete the old public_ip and instance_id outputs as they don't apply to a group of servers
