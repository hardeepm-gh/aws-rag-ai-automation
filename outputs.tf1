# 1. The Database Endpoint (The address your app will use to connect)
output "rds_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.app_db.endpoint
}

# 2. The VPC ID (Useful for future security group peering)
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# 3. The S3 Bucket Name
output "s3_bucket_name" {
  description = "The name of the Knowledge Lake bucket"
  value       = aws_s3_bucket.knowledge_lake.id
}