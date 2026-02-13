output "vpc_id_from_module" {
  value = aws_vpc.this.id
}

output "public_subnet_id" {
  value = aws_subnet.this.id
}