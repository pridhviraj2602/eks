variable "cluster_name" {
  description = "Name of the on-prem EKS Anywhere cluster"
  type        = string
}

variable "cidr" {
  description = "CIDR block for on-prem infrastructure"
  type        = string
}

variable "node_count" {
  description = "Number of worker nodes for the on-prem cluster"
  type        = number
  default     = 1
}

variable "provider" {
  description = "On-prem provider (e.g., redhat-openshift)"
  type        = string
  default     = "redhat-openshift"
}

resource "null_resource" "eks_anywhere" {
  provisioner "local-exec" {
    command = "eksctl anywhere create cluster --name ${var.cluster_name} --cidr ${var.cidr} --nodes ${var.node_count} --provider ${var.provider}"
  }

  triggers = {
    cluster_name = var.cluster_name
    cidr         = var.cidr
    node_count   = var.node_count
    provider     = var.provider
  }
}

output "cluster_name" {
  description = "The on-prem EKS Anywhere cluster name"
  value       = var.cluster_name
}
