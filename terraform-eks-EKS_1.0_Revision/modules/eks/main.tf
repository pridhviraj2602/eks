
locals {
  cluster_configs = {
    "il2-eks-dmz" = {
      vpc_module   = true
      eks_module   = true
      monitoring   = false
      transit_gw   = false
    }
    "il2-eks-transit" = {
      vpc_module   = true
      eks_module   = false
      monitoring   = false
      transit_gw   = true
    }
    "il2-eks-core-services" = {
      vpc_module   = true
      eks_module   = true
      monitoring   = true
      transit_gw   = false
    }
    "il2-eks-devsecops" = {
      vpc_module   = true
      eks_module   = true
      monitoring   = true
      transit_gw   = false
    }
    "il5-eks-dmz" = {
      vpc_module   = true
      eks_module   = true
      monitoring   = false
      transit_gw   = false
    }
    "il5-eks-transit" = {
      vpc_module   = true
      eks_module   = false
      monitoring   = false
      transit_gw   = true
    }
    "il5-eks-core-services" = {
      vpc_module   = true
      eks_module   = true
      monitoring   = true
      transit_gw   = false
    }
    "il5-eks-devsecops" = {
      vpc_module   = true
      eks_module   = true
      monitoring   = true
      transit_gw   = false
    }
  }
}

locals {
  application_mappings = {
    "ApplicationA" = ["il2-eks-dmz", "il2-eks-transit"]
    "ApplicationB" = ["il2-eks-core-services"]
    "ApplicationC" = ["il2-eks-devsecops"]
  }
}

# VPC Module
module "vpc" {
  source      = "./modules/vpc"
  region      = var.region
  vpc_cidr    = var.vpc_cidr
  subnet_cidrs = var.subnet_cidrs
  count       = local.cluster_configs[var.env_cluster].vpc_module ? 1 : 0
}

# EKS Module (Only enabled for clusters requiring Kubernetes)
module "eks" {
  source       = "./modules/eks"
  cluster_name = var.cluster_name
  vpc_id       = module.vpc[0].vpc_id
  subnet_ids   = module.vpc[0].subnet_ids
  count        = local.cluster_configs[var.env_cluster].eks_module ? 1 : 0
}

# Monitoring Module (Enabled for core-services & devsecops)
module "monitoring" {
  source       = "./modules/monitoring"
  cluster_name = var.cluster_name
  eks_cluster_id = module.eks[0].cluster_id
  count        = local.cluster_configs[var.env_cluster].monitoring ? 1 : 0
}

# Transit Gateway Module (Only for transit VPC)
module "transit_gateway" {
  source = "./modules/transit-gateway"
  vpc_id = module.vpc[0].vpc_id
  count  = local.cluster_configs[var.env_cluster].transit_gw ? 1 : 0
}

# Deploy Applications
module "applications" {
  source       = "./modules/application"
  cluster_name = var.cluster_name
  application  = var.application
  eks_cluster_id = module.eks[0].cluster_id

  count = contains(local.application_mappings[var.application], local.env_cluster) ? 1 : 0
}





