output "cluster_id" {
  description = "The ID of the EKS cluster"
  value       = aws_eks_cluster.this.id
}

output "cluster_endpoint" {
  description = "The EKS cluster API endpoint"
  value       = data.aws_eks_cluster.this.endpoint
}

output "cluster_ca_certificate" {
  description = "The cluster CA certificate"
  value       = data.aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_auth_token" {
  description = "The authentication token for the cluster"
  value       = data.aws_eks_cluster_auth.this.token
}

output "node_asg_name" {
  description = "The name of the Auto Scaling Group for worker nodes"
  value       = aws_autoscaling_group.nodes_asg.name
}
