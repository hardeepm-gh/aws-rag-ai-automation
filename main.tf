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

# ✅ Mapping to the specific names your module requires:
 # web_sg_id      = module.security.ec2_sg_id      # Maps to 'web_sg_id'
 # public_subnets = module.vpc.private_subnets      # Maps to 'public_subnets'

  # IAM and Load Balancer
 # iam_instance_profile_name = module.security.iam_instance_profile_name
 # target_group_arn          = aws_lb_target_group.app_tg.arn

# Fix the typo: Change 'mmodule' to 'module'
module "ec2" {
  source = "./modules/ec2"

  env           = var.env
  ami_id        = var.ami_id
  instance_type = var.instance_type
  vpc_id        = module.vpc.vpc_id

  # ✅ Satisfy the arguments the EC2 module is demanding:
  public_subnets = module.vpc.private_subnets 
  web_sg_id      = module.security.ec2_sg_id

  # Ensure these are also included if your module requires them:
  security_group_id         = module.security.ec2_sg_id
  private_subnets           = module.vpc.private_subnets
  iam_instance_profile_name = module.security.iam_instance_profile_name
  # Correct way: module.<MODULE_NAME>.<OUTPUT_NAME>
  target_group_arn = module.alb.target_group_arn
}
module "alb" {
  source         = "./modules/alb"
  env            = var.env
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  alb_sg_id      = module.security.alb_sg_id
}





