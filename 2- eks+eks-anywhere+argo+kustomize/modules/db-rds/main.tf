variable "engine" {
  description = "Database engine (postgres or mysql)"
  type        = string
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "username" {
  description = "Database username"
  type        = string
}

variable "password" {
  description = "Database password"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "Security group IDs to associate with the DB instance"
  type        = list(string)
  default     = []
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.medium"
}

resource "aws_db_subnet_group" "this" {
  name       = "db-subnet-group-${var.db_name}"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "this" {
  identifier             = "${var.db_name}-db"
  engine                 = var.engine
  instance_class         = var.instance_class
  allocated_storage      = 20
  name                   = var.db_name
  username               = var.username
  password               = var.password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.vpc_security_group_ids
  skip_final_snapshot    = true
  publicly_accessible    = false
  storage_encrypted      = true
  multi_az               = false
  deletion_protection    = false
}

output "db_endpoint" {
  description = "The endpoint address of the DB instance"
  value       = aws_db_instance.this.endpoint
}

output "db_username" {
  description = "Database username"
  value       = var.username
}

output "db_password" {
  description = "Database password"
  value       = var.password
}
