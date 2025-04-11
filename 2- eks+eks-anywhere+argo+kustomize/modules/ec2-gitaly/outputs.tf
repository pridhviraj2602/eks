output "gitaly_instance_ids" {
  description = "IDs of Gitaly EC2 instances"
  value       = aws_instance.gitaly[*].id
}

output "gitaly_instance_public_ips" {
  description = "Public IPs of Gitaly EC2 instances"
  value       = aws_instance.gitaly[*].public_ip
}
