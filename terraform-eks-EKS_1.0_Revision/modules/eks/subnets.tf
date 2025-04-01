resource "aws_subnet" "eks_cluster_subnets" {
    for_each = var.eks_cluster_subnets
    vpc_id = var.eks_vpc_id
    availability_zone = each.value.availability_zone
    cidr_block = each.value.cidr_block
    tags = {
        Name = "${var.organization}-${var.project}-${var.cluster_name}-subnet-1"
        Terraform = true
        Environment = var.env_name
    }
}

locals {
  eks_cluster_subnet_ids = [for subnet in aws_subnet.eks_cluster_subnets : subnet.id]
}