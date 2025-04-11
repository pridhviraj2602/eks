resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = merge(
    var.tags,
    { Name = "vpc-${var.vpc_cidr}" }
  )
}

resource "aws_subnet" "subnets" {
  count                   = length(var.subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.subnet_cidrs, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true
  tags = merge(
    var.tags,
    { Name = "subnet-${element(var.subnet_cidrs, count.index)}" }
  )
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = aws_subnet.subnets[*].id
}

data "aws_availability_zones" "available" {}
