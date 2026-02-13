# 1. The Network Module (The Land)
module "development_network" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  env      = "dev"
}

# 2. RDS Subnet Group (The Bridge)
resource "aws_db_subnet_group" "this" {
  name       = "main-db-subnet-group"
  # Pulls the subnet ID created inside your module
  subnet_ids = [module.development_network.public_subnet_id]

  tags = {
    Name = "My DB Subnet Group"
  }
}

# 3. The Database (The House)
resource "aws_db_instance" "db" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = "mydb"
  username             = "admin"
  password             = "password123" # In production, use a Secret Manager!
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  
  # Links the DB to the subnet group above
  db_subnet_group_name = aws_db_subnet_group.this.name
}

