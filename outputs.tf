output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "web_server_public_ip" {
  value = module.web_server.public_ip
}

output "rds_endpoint" {
  description = "The endpoint of the RDS database"
  value       = module.db.db_instance_endpoint
}