###############################
# Cloud Infrastructure
###############################
module "vpc" {
  source       = "./modules/vpc"
  region       = var.region
  vpc_cidr     = var.vpc_cidr
  subnet_cidrs = var.cloud_subnet_cidrs
}

module "eks_cloud" {
  source        = "./modules/eks"
  region        = var.region
  cluster_name  = var.eks_cluster_name   # Options: "eks-core-services", "eks-devsecops", or "eks-dmz"
  subnet_ids    = module.vpc.subnet_ids
  worker_ami_id = var.universal_ami_id     # Universal AMI built by Packer
  worker_instance_type = var.eks_cluster_name == "eks-core-services" ? "r5d.2xlarge" : "t3.medium"
  node_asg_min_size = var.eks_cluster_name == "eks-core-services" ? 3 : 1
  node_asg_desired_capacity = var.eks_cluster_name == "eks-core-services" ? 3 : 1
  node_asg_max_size = var.eks_cluster_name == "eks-core-services" ? 3 : 1
  worker_security_group_ids = [module.vpc.default_sg_id]
  tags = var.tags
}

###############################
# On-Prem EKS Anywhere Infrastructure
###############################
module "eks_anywhere_core_services" {
  source       = "./modules/eks-anywhere"
  cluster_name = "eks-anywhere-core-services"
  cidr         = var.onprem_cidr
  node_count   = 3
  provider     = var.eks_anywhere_provider
}

module "eks_anywhere_devsecops" {
  source       = "./modules/eks-anywhere"
  cluster_name = "eks-anywhere-devsecops"
  cidr         = var.onprem_cidr
  node_count   = 1
  provider     = var.eks_anywhere_provider
}

module "eks_anywhere_dmz" {
  source       = "./modules/eks-anywhere"
  cluster_name = "eks-anywhere-dmz"
  cidr         = var.onprem_cidr
  node_count   = 1
  provider     = var.eks_anywhere_provider
}

###############################
# Additional Modules (e.g., Apps, EC2 for Gitaly)
###############################
module "app_keycloak" {
  source       = "./modules/app-keycloak"
  cluster_name = module.eks_cloud.cluster_id
  db_endpoint  = try(module.db_keycloak[0].db_endpoint, "")
  db_username  = try(module.db_keycloak[0].db_username, "")
  db_password  = try(module.db_keycloak[0].db_password, "")
}

module "ec2_gitaly" {
  source           = "./modules/ec2-gitaly"
  region           = var.region
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.subnet_ids
  universal_ami_id = var.universal_ami_id
  instance_type    = var.worker_instance_type
  key_name         = var.ec2_key_name
  gitaly_count     = var.gitaly_count
  tags             = var.tags
}
