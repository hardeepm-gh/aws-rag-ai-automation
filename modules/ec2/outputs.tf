output "asg_name" {
  value = aws_autoscaling_group.this.name
}

# Delete the old public_ip and instance_id outputs as they don't apply to a group of servers