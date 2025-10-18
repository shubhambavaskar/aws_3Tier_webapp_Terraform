variable "project_name" { type = string }
variable "vpc_id" { type = string }
variable "db_subnet_ids" { type = list(string) }
variable "db_sg_id" { type = string }
variable "db_username" { type = string }
variable "db_password" { type = string }
variable "db_allocated_storage" { type = number }
variable "db_instance_class" { type = string }
variable "env" { type = string }

resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.db_subnet_ids
  tags = { Name = "${var.project_name}-db-subnet-group" }
}

resource "aws_db_instance" "app_db" {
  identifier              = "${var.project_name}-db"
  allocated_storage       = var.db_allocated_storage
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = var.db_instance_class
  name                    = "appdb"
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = true
  publicly_accessible     = false
  vpc_security_group_ids  = [var.db_sg_id]
  db_subnet_group_name    = aws_db_subnet_group.this.name
  multi_az                = false

  tags = {
    Name = "${var.project_name}-rds"
    Env  = var.env
  }
}
