output "final_vpc_id" {
  description = "The ID of the VPC created via the module"
  value       = module.development_network.vpc_id_from_module
}

output "db_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.db.endpoint
}