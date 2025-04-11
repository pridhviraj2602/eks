output "eks_cloud_cluster_id" {
  description = "ID of the cloud EKS cluster"
  value       = module.eks_cloud.cluster_id
}

output "onprem_eks_clusters" {
  description = "Names of the on-prem EKS Anywhere clusters"
  value = [
    module.eks_anywhere_core_services.cluster_name,
    module.eks_anywhere_devsecops.cluster_name,
    module.eks_anywhere_dmz.cluster_name
  ]
}

output "universal_ami_id" {
  description = "ID of the universal AMI"
  value       = var.universal_ami_id
}

output "gitaly_instance_public_ips" {
  description = "Public IPs for the Gitaly EC2 instances"
  value       = module.ec2_gitaly.gitaly_instance_public_ips
}
