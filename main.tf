# --- PROVIDER CONFIGURATION ---
provider "aws" {
  region = "us-east-1"
}

# --- 1. NETWORK (VPC) ---
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.0"

  name = "hardeep-enterprise-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true 
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = "Dev"
    Project     = "Cloud-Transformation"
    ManagedBy   = "Terraform"
  }
}

# --- 2. DATABASE (RDS) ---
resource "aws_db_subnet_group" "database" {
  name       = "hardeep-db-subnet-group"
  subnet_ids = module.vpc.public_subnets

  tags = {
    Name = "My DB Subnet Group"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "database-security-group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "app_db" {
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t3.micro"
  db_name                = "it_knowledge_db"
  username               = "hardeep_admin"
  password               = "SecurePassword123!" 
  db_subnet_group_name   = aws_db_subnet_group.database.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = true
}

# --- 3. STORAGE (S3 KNOWLEDGE LAKE) ---
resource "aws_s3_bucket" "knowledge_lake" {
# This will result in names like: hardeep-lake-a1b2
  bucket = "hardeep-lake-${random_string.suffix.result}"
  force_destroy = true 

  tags = {
    Name        = "IT-Knowledge-Lake"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "lake_versioning" {
  bucket = aws_s3_bucket.knowledge_lake.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "lake_security" {
  bucket = aws_s3_bucket.knowledge_lake.id
  block_public_acls       = true
  block_public_policy      = true
  ignore_public_acls       = true
  restrict_public_buckets  = true
}

# --- 4. PERMISSIONS (IAM) ---
resource "aws_iam_role" "ai_assistant_role" {
  name = "it-assistant-role-${random_string.suffix.result}"
}

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com" # Or bedrock.amazonaws.com depending on your use case
        }
      }
    ]
  })
}

# THE ROLE (This one uses assume_role_policy)
resource "aws_iam_role" "ai_assistant_role" {
  name = "it-assistant-role-${random_string.suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com" # Or bedrock.amazonaws.com depending on your use case
        }
      }
    ]
  })
}

# THE POLICY (This one uses "policy =", NOT "assume_role_policy")
resource "aws_iam_policy" "ai_assistant_policy" {
  name = "ai-assistant-perm-${random_string.suffix.result}"
  
  policy = jsonencode({  # <--- Make sure this says 'policy', not 'assume_role_policy'
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:GetObject", "s3:ListBucket"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
        Action   = ["rds-db:connect"]
        Effect   = "Allow"
        Resource = [aws_db_instance.app_db.arn]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ai_attach" {
  role       = aws_iam_role.ai_assistant_role.name
  policy_arn = aws_iam_policy.ai_assistant_policy.arn
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}
