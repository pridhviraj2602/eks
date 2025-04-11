output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = aws_subnet.subnets[*].id
}

output "default_sg_id" {
  value = aws_vpc.main.default_security_group_id
}
