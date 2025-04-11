variable "region" {
  type        = string
  description = "AWS region"
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the cluster"
}

variable "worker_ami_id" {
  description = "AMI for worker nodes"
  type        = string
}

variable "worker_instance_type" {
  type        = string
  description = "Instance type for worker nodes"
  default     = "t3.medium"
}

variable "worker_security_group_ids" {
  type        = list(string)
  description = "Security group IDs for worker nodes"
  default     = []
}

variable "node_asg_min_size" {
  type        = number
  description = "Minimum number of worker nodes"
  default     = 1
}

variable "node_asg_max_size" {
  type        = number
  description = "Maximum number of worker nodes"
  default     = 3
}

variable "node_asg_desired_capacity" {
  type        = number
  description = "Desired number of worker nodes"
  default     = 1
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}
