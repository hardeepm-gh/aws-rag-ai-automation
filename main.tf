module "vpc" {
  source   = "./modules/vpc"
  env      = var.env
  vpc_cidr = "10.0.0.0/16" # Added this missing argument
}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
  env    = var.env
}

module "web_server" {
  source            = "./modules/ec2"
  env               = var.env
  subnet_id         = module.vpc.public_subnet_ids[0]
  security_group_id = module.security.web_sg_id 
}

# 3. Provide the Database (The Data Tier)
module "db" {
  source               = "./modules/rds"
  db_name              = "devdb"
  db_username          = "admin"
  db_password          = "password123" # In Day 23, we will move this to a secret!
  vpc_id               = module.vpc.vpc_id
  db_subnet_group_name = module.vpc.db_subnet_group_name
  # db_security_group_id = module.security.db_sg_id
  web_server_sg_id     = module.security.web_sg_id # Use the security module's output directly!
}


# Data source to find the latest Amazon Linux AMI automatically
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}