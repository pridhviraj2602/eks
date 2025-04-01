output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_auth_base64" {
    value = module.eks.cluster_certificate_authority_data
}

output "cluster_primary_security_group_id" {
    value = module.eks.cluster_primary_security_group_id
}

output "cluster_security_group_id" {
    value = module.eks.cluster_security_group_id
}
