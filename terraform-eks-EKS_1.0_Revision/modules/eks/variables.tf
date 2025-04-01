# Input variables
variable "cluster_name" {
  type        = string
  default     = "my-tf-eks-cluster"
  description = "The name of your EKS Cluster"
}

variable "cluster_version" {
  type        = string
  default     = "1.31"
  description = "The version of your EKS Cluster"
}

variable "env_name" {
  type        = string
  default     = "dev"
  description = "The name of your environment"
}

variable "cluster_iam_role" {
  type        = string
  default     = "null"
  description = "The existing IAM role for your EKS Cluster."
}

variable "eks_vpc_id" {
  type        = string
  default     = "null"
  description = "The existing vpc for your EKS Cluster."
}

variable "admin_iam_role" {
  type        = string
  default     = "null"
  description = "The ARN of an administrator IAM Role that should have access to your cluster."
}

variable "admin_user_name" {
  type = string
  default = "PROJADMIN"
  description = "The beginning of the assumed role"
}

variable "organization" {
  type        = string
  default     = "AFS"
  description = "The name of your organization"
}

variable "project" {
  type        = string
  default     = "RADON-U"
  description = "The name of your project"
}

variable "nodegroup_iam_role" {
  type        = string
  default     = "null"
  description = "The ARN of existing IAM role for your nodegroups."
}

variable "eks_cluster_subnets" {
  type = map(object({
    cidr_block = string
    availability_zone = string 
  }))
  default = {
  subnet =  {
      cidr_block = "10.0.0.0/28"
      availability_zone = "us-gov-west-1a"
    }
  }
  description = "A list of subnets for the cluster, should be /28's."
}

variable "eks_nodegroups" {
  type = map(object({
    name            = string
    instance_type  = string
    node_group_name = string
    min_size   = number
    max_size    = number
    desired_size    = number
    key_name    = string
    tags    = map(string)
    subnets         = map(object({
      cidr_block = string
      availability_zone = string
      existing_subnet_id = string
    }))
  }))
  default = {
    nodegroup1 = {
      name            = "nodegroup1"
      instance_type  = "t3.medium"
      node_group_name = "nodegroup1"
      min_size   = 1
      max_size  = 3
      desired_size  = 2
      key_name = "my_ssh_key"
      tags  = {
        Name = "Nodegroup1"
      }
      subnets         = {
        subnet1 = {
          cidr_block = "10.0.1.0/24"
          availability_zone = "us-gov-west-1a"
          existing_subnet_id = null
        }
        subnet2 = {
          cidr_block = "10.0.2.0/24"
          availability_zone = "us-gov-west-1b"
          existing_subnet_id = null
        }
        subnet3 = {
          cidr_block = null
          availability_zone = null
          existing_subnet_id = "subnet-1234556"
        }
      }
    }
  }
  description = "A list of nodegroups for the cluster, including subnets for each nodegroup. if a new subnet is required, specify cidr and AZ otherwise leave null and provide subnet ID."
}

variable "proxy_hostname" {
  type = string
  default = "myproxy.test"
  description = "URL or IP to your proxy"
}

variable "proxy_port" {
  type = string
  default = "3128"
  description = "port to your proxy"
}

variable "cluster_service_cidr" {
  type = string
  default = "10.5.0.0/16"
  description = "A CIDR that doesn't conflict with your VPC, used for eks services."
}

variable "no_proxy" {
  type = string
  default = "10.50.0.0/16,10.100.0.0/16,172.20.0.0/16,127.0.0.1,169.254.169.254,127.0.0.1,localhost,localhost.localdomain,*.cluster.local,*.svc"
  description = "URL's, IP's and subnets that should not use proxy settings"
}