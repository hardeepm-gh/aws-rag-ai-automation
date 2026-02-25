module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  # Use 'name' instead of 'env'
  name = "${var.env}-vpc"

  # Use 'cidr' instead of 'vpc_cidr'
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  # The "Advanced Challenge" components
  enable_nat_gateway = true
  single_nat_gateway = true
}


module "security" {
  source = "./modules/Security"
  vpc_id = module.vpc.vpc_id
  env    = var.env
}

module "rds" {
  source          = "./modules/rds"
  env             = var.env
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  db_password     = var.db_password
  db_sg_id        = module.security.db_sg_id # Now this exists!

}


module "ec2" {
  source = "./modules/ec2"
  env    = var.env

  # 1. Provide the VPC ID from the VPC module
  vpc_id = module.vpc.vpc_id

  # 2. Provide the AMI ID (Amazon Linux 2023 in us-east-1)
  ami_id = "ami-0440d3b780d96b29d" 

  # Ensure your subnet mapping is still correct
  public_subnets = module.vpc.private_subnets 

  instance_type    = "t3.micro"
  web_sg_id        = module.security.web_sg_id
  target_group_arn = module.alb.target_group_arn
  db_endpoint      = module.rds.db_endpoint

  depends_on = [module.alb, module.rds]
}




module "alb" {
  source         = "./modules/alb"
  env            = var.env
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  alb_sg_id      = module.security.alb_sg_id
}

