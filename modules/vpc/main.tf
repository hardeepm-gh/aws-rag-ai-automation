resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags                 = { Name = "${var.env}-vpc" }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "${var.env}-igw" }
}

resource "aws_subnet" "public_az1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a" # Adjust for your region
  tags              = { Name = "${var.env}-public-1a" }
}

resource "aws_subnet" "public_az2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b" # Adjust for your region
  tags              = { Name = "${var.env}-public-1b" }
}

# ... (Keep your VPC, IGW, and Subnet resources here) ...


# 1. Create the Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id 
  }

  tags = { Name = "${var.env}-public-rt" }
}

# 2. Associate it with Subnet 1
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_route_table.public.id
}

# 3. Associate it with Subnet 2
resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_az2.id
  route_table_id = aws_route_table.public.id
}