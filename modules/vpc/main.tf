resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = { Name = "${var.env}-vpc" }
}

# 1. The Gateway (The Door)
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "${var.env}-igw" }
}

# 2. Create two public subnets in different AZs
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = { Name = "${var.env}-public-subnet-${count.index}" }
}

# Add this data source at the top of the file to get AZ names automatically
data "aws_availability_zones" "available" {
  state = "available"
}

# Update the association to handle the list of subnets
resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# 3. The Route Table (The Instructions to the Door)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

# 4. The Association (Applying instructions to the Room)
#resource "aws_route_table_association" "public" {
  # subnet_id      = aws_subnet.this.id
  #route_table_id = aws_route_table.public.id
# }
# ... (your existing VPC and Subnet resources)

resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = aws_subnet.public[*].id # Uses all public subnets created in this module
}
 
