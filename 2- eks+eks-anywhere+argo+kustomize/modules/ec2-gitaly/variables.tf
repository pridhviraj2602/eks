variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "universal_ami_id" {
  description = "AMI for Gitaly (Universal AMI built by Packer)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "EC2 key name"
  type        = string
  default     = ""
}

variable "gitaly_count" {
  description = "Number of Gitaly instances"
  type        = number
  default     = 3
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
