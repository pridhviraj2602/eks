output "db_endpoint" {
  description = "The DB instance endpoint"
  value       = aws_db_instance.this.endpoint
}

output "db_username" {
  description = "DB username"
  value       = var.username
}

output "db_password" {
  description = "DB password"
  value       = var.password
}
