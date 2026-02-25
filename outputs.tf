# output "alb_dns_name" {
# value = module.alb.alb_dns_name
# }

# output "web_server_instance_id" {
# value = module.web_server.instance_id
# }

output "db_connection_endpoint" {
  description = "The address of the RDS instance"
  value       = module.rds.db_endpoint
}

output "load_balancer_url" {
  description = "The URL to access your web application"
  value       = "http://${module.alb.alb_dns_name}"
}