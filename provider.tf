# 1. Define the AWS Provider
provider "aws" {
  region = "us-east-1" 
}

# 2. Configure the Modern Remote Backend (2026 Standards)
terraform {
  # backend "s3" {
    # bucket       = "hardeep-terraform-state-01726" # Your bucket name
    # key          = "global/s3/terraform.tfstate"
    # region       = "us-east-1"
    # encrypt      = true
    
    # NEW 2026 STANDARD: Replaces dynamodb_table
    # use_lockfile = true 
  }
