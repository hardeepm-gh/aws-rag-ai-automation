# --- 1. TERRAFORM & PROVIDER CONFIG ---
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" 
}

# --- 2. RANDOM SUFFIX ---
# This ensures unique names for S3 and IAM to avoid "AlreadyExists" errors
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# --- 3. NETWORKING (VPC) ---
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.0"

  name = "hardeep-enterprise-vpc-${random_string.suffix.result}"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  database_subnets = ["10.0.201.0/24", "10.0.202.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true # Keeps us under the Elastic IP limit
}

# --- 4. DATABASE (RDS POSTGRES) ---
resource "aws_security_group" "rds_sg" {
  name   = "rds-sg-${random_string.suffix.result}"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
}

resource "aws_db_subnet_group" "database" {
  name       = "db-subnet-group-${random_string.suffix.result}"
  subnet_ids = module.vpc.database_subnets
}

resource "aws_db_instance" "app_db" {
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t3.micro"
  db_name                = "ragdb"
  username               = "dbadmin"
  password               = "HardeepSecurePass2026!"
  db_subnet_group_name   = aws_db_subnet_group.database.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
}

# --- 5. STORAGE (S3 KNOWLEDGE LAKE) ---
resource "aws_s3_bucket" "knowledge_lake" {
  bucket        = "hardeep-rag-lake-${random_string.suffix.result}"
  force_destroy = true 
}

# --- 6. IDENTITY & PERMISSIONS (IAM) ---
resource "aws_iam_role" "ai_assistant_role" {
  name = "it-assistant-role-${random_string.suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_policy" "ai_assistant_policy" {
  name = "ai-assistant-perm-${random_string.suffix.result}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:GetObject", "s3:ListBucket"]
        Effect   = "Allow"
        Resource = [
          aws_s3_bucket.knowledge_lake.arn,
          "${aws_s3_bucket.knowledge_lake.arn}/*"
        ]
      },
      {
        Action   = ["bedrock:InvokeModel"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_perms" {
  role       = aws_iam_role.ai_assistant_role.name
  policy_arn = aws_iam_policy.ai_assistant_policy.arn
}

# --- 7. OUTPUTS ---
output "rds_endpoint" {
  value = aws_db_instance.app_db.endpoint
}

output "s3_bucket_name" {
  value = aws_s3_bucket.knowledge_lake.id
}