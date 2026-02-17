# Provide the Network (The Foundation)
module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16" # The network range for your VPC
  env      = "dev"          # The environment name for tagging
}

# ... (the rest of your module blocks for web_server and db remain the same)

# 1. Provide the Network (The Foundation)
# module "vpc" {
  # source = "./modules/vpc"
# }

# 2. Provide the Web Server (The Compute Tier)
module "web_server" {
  source    = "./modules/ec2"
  ami_id    = data.aws_ami.latest_amazon_linux.id
  subnet_id = module.vpc.public_subnet_id
  vpc_id    = module.vpc.vpc_id
  env       = "dev"
}

# 3. Provide the Database (The Data Tier)
module "db" {
  source               = "./modules/rds"
  db_name              = "devdb"
  db_username          = "admin"
  db_password          = "password123" # In Day 23, we will move this to a secret!
  vpc_id               = module.vpc.vpc_id
  db_subnet_group_name = module.vpc.db_subnet_group_name
  web_server_sg_id     = module.web_server.security_group_id
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