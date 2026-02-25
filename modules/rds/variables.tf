variable "env" {}
variable "vpc_id" {}
variable "private_subnets" { type = list(string) }
variable "db_password" { sensitive = true }
variable "db_sg_id" {} # Make sure this matches the name in root main.tf