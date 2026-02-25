# This block ONLY groups the subnets
resource "aws_db_subnet_group" "this" {
  name       = "${var.env}-rds-subnet-group"
  subnet_ids = var.private_subnets

  tags = { Name = "${var.env}-db-subnet-group" }
}

# This block is the ACTUAL database
resource "aws_db_instance" "this" {
  identifier             = "${var.env}-database"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = "production_db"
  username               = "admin"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.db_sg_id]


  multi_az            = true
  skip_final_snapshot = true
  publicly_accessible = false
  deletion_protection = false
}