output "eks_cluster_id" {
  value = module.eks[*].cluster_id
}

output "transit_gateway_id" {
  value = module.transit_gateway[*].id
}