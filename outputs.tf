output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "web_server_instance_id" {
  value = module.web_server.instance_id
}