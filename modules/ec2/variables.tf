variable "env" {}
variable "vpc_id" {}
variable "public_subnets" { type = list(string) }
variable "web_sg_id" {}
variable "ami_id" {}
variable "instance_type" {}
variable "target_group_arn" {}
variable "db_endpoint" {}