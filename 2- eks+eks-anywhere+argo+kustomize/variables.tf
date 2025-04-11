variable "region" {
  description = "AWS region for cloud resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the cloud VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cloud_subnet_cidrs" {
  description = "Subnets for cloud VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "eks_cluster_name" {
  description = "Name of the cloud EKS cluster. Valid values: 'eks-core-services', 'eks-devsecops', or 'eks-dmz'"
  type        = string
  default     = "eks-core-services"
}

variable "universal_ami_id" {
  description = "ID of the universal (golden) AMI built by Packer"
  type        = string
  default     = ""
}

variable "worker_instance_type" {
  description = "Default instance type for workers"
  type        = string
  default     = "t3.medium"
}

variable "node_asg_min_size" {
  description = "Default minimum nodes for EKS worker node ASG"
  type        = number
  default     = 1
}

variable "node_asg_max_size" {
  description = "Default maximum nodes for EKS worker node ASG"
  type        = number
  default     = 3
}

variable "node_asg_desired_capacity" {
  description = "Default desired capacity for EKS worker node ASG"
  type        = number
  default     = 1
}

variable "ec2_key_name" {
  description = "EC2 SSH key name"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {
    Environment = "production"
    Project     = "MultiCluster"
  }
}

###############################
# On-Prem Variables
###############################
variable "onprem_cidr" {
  description = "CIDR block for on-prem infrastructure (EKS Anywhere)"
  type        = string
  default     = "10.11.0.0/17"
}

variable "eks_anywhere_provider" {
  description = "On-prem provider (e.g., 'redhat-openshift')"
  type        = string
  default     = "redhat-openshift"
}

###############################
# Gitaly Configuration
###############################
variable "gitaly_count" {
  description = "Number of EC2 instances for Gitaly"
  type        = number
  default     = 3
}
