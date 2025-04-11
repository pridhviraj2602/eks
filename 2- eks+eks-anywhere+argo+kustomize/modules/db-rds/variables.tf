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
  description = "Security group IDs for the DB instance"
  type        = list(string)
  default     = []
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.medium"
}
