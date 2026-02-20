module "vpc" {
  source   = "./modules/vpc"
  env      = var.env
  vpc_cidr = "10.0.0.0/16" # This fixes the "Missing required argument" error
}

module "security" {
  source = "./modules/security"
  env    = var.env
  vpc_id = module.vpc.vpc_id
}

module "web_server" {
  source            = "./modules/ec2"
  env               = var.env
  ami_id            = var.ami_id
  instance_type     = "t2.micro"
  subnet_id         = module.vpc.public_subnet_ids[0]
  security_group_id = module.security.web_sg_id
}

module "alb" {
  source            = "./modules/alb"
  env               = var.env
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security.alb_sg_id
  web_server_id     = module.web_server.instance_id
}