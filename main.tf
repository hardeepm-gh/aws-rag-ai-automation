module "vpc" {
  source = "./modules/vpc"
  env    = var.env
  vpc_cidr = "10.0.0.0/16"
}

module "security" {
  source = "./modules/security"
  env    = var.env
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source         = "./modules/alb"
  env            = var.env
  vpc_id         = module.vpc.vpc_id
  alb_sg_id      = module.security.alb_sg_id
  public_subnets = module.vpc.public_subnets
}

module "ec2" {
  source           = "./modules/ec2"
  env              = var.env
  ami_id           = "ami-0c101f26f147fa7fd" # Ensure correct for your region
  instance_type    = "t2.micro"
  web_sg_id        = module.security.web_sg_id
  public_subnets   = module.vpc.public_subnets
  target_group_arn = module.alb.target_group_arn
}

module "monitoring" {
  source                 = "./modules/monitoring"
  env                    = var.env
  alb_arn_suffix         = module.alb.alb_arn_suffix
  target_group_arn_suffix = module.alb.target_group_arn_suffix
}