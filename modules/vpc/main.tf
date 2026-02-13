# The VPC must be declared first!
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "${var.env}-vpc"
  }
}

# The Subnet needs the VPC ID from above
resource "aws_subnet" "this" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "${var.env}-public-subnet"
  }
}

