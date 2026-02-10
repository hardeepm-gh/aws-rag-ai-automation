module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.0"

  name = "hardeep-enterprise-vpc"
  cidr = "10.0.0.0/16"

  # High Availability across 2 Availability Zones
  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  # Standard Enterprise Gateways
  enable_nat_gateway = true
  single_nat_gateway = true # Cost-efficiency for development
  
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = "Dev"
    Project     = "Cloud-Transformation"
    ManagedBy   = "Terraform"
  }
}
# 1. Manually define the DB Subnet Group to ensure the RDS "sees" it
resource "aws_db_subnet_group" "database" {
  name       = "hardeep-db-subnet-group"
  subnet_ids = module.vpc.public_subnets # Explicitly uses the private IDs

  tags = {
    Name = "My DB Subnet Group"
  }
}

# 2. Security Group (Same as before)
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

# 3. The RDS Instance - Now pointing to our MANUALLY created group
resource "aws_db_instance" "app_db" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "15"
  instance_class       = "db.t3.micro"
  db_name              = "it_knowledge_db"
  username             = "hardeep_admin"
  password             = "SecurePassword123!" 
  
  # CHANGE HERE: Use the name of the resource we just created above
  db_subnet_group_name   = aws_db_subnet_group.database.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  
  skip_final_snapshot  = true
  publicly_accessible  = true

}
# 1. The Data Lake Bucket
resource "aws_s3_bucket" "knowledge_lake" {
  bucket        = "hardeep-it-assistant-knowledge-lake-dev-01"
  
  # This tells AWS: "Delete this bucket even if it has files/versions inside"
  force_destroy = true 

  tags = {
    Name        = "IT-Knowledge-Lake"
    Environment = "Dev"
  }
}

# 2. Enable Versioning (Safety First)
resource "aws_s3_bucket_versioning" "lake_versioning" {
  bucket = aws_s3_bucket.knowledge_lake.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 3. Block All Public Access (Security Best Practice)
resource "aws_s3_bucket_public_access_block" "lake_security" {
  bucket = aws_s3_bucket.knowledge_lake.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
# 1. Create the IAM Role
resource "aws_iam_role" "ai_assistant_role" {
  name = "it-knowledge-assistant-role"

  # This allows AWS services (like Lambda or EC2) to "put on" this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com" # We'll likely use Lambda for the AI logic
        }
      },
    ]
  })
}

# 2. Define the "Least Privilege" Policy
resource "aws_iam_policy" "ai_assistant_policy" {
  name        = "ai-assistant-permissions"
  description = "Allows reading from S3 Knowledge Lake and connecting to RDS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # Permission to list and read files from your S3 bucket
        Action   = ["s3:GetObject", "s3:ListBucket"]
        Effect   = "Allow"
        Resource = [
          aws_s3_bucket.knowledge_lake.arn,
          "${aws_s3_bucket.knowledge_lake.arn}/*"
        ]
      },
      {
        # Permission to connect to the RDS instance
        Action   = ["rds-db:connect"]
        Effect   = "Allow"
        Resource = [aws_db_instance.app_db.arn]
      }
    ]
  })
}

# 3. Attach the Policy to the Role
resource "aws_iam_role_policy_attachment" "ai_attach" {
  role       = aws_iam_role.ai_assistant_role.name
  policy_arn = aws_iam_policy.ai_assistant_policy.arn
}
terraform {
  backend "s3" {
    bucket = "hard05-terraform-state-bucket"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
}
resource "aws_s3_bucket" "test_bucket" {
  bucket = "rag-ai-test-bucket-${random_id.id.hex}"
}

resource "random_id" "id" {
  byte_length = 4
}