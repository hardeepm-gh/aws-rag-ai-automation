resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  # Reference the resource in this file, NOT a variable
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "${var.env}-web-server"
  }
}

resource "aws_security_group" "web_sg" {
  name   = "${var.env}-web-sg"
  vpc_id = var.vpc_id
  # ... (ingress/egress rules)
}

# resource "aws_security_group" "web_sg" {
 # name        = "web-server-sg"
  # description = "Allow HTTP inbound traffic"
  # vpc_id      = var.vpc_id

  
  # user_data = <<-EOF
              #!/bin/bash
              # echo "Hello from Day 21" > index.html
              # nohup python3 -m http.server 80 &
              # EOF

  # tags = {
   #  Name = "${var.env}-web-server"
  }
