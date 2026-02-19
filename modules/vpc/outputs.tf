output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  # This collects all IDs from the 'public' count into a single list
  value = aws_subnet.public[*].id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.main.name
}