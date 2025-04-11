variable "cluster_name" {
  description = "Name of the on-prem EKS Anywhere cluster"
  type        = string
}

variable "cidr" {
  description = "CIDR block for on-prem infrastructure"
  type        = string
}

variable "node_count" {
  description = "Number of nodes in the on-prem cluster"
  type        = number
  default     = 1
}

variable "provider" {
  description = "Provider for on-prem (e.g., redhat-openshift)"
  type        = string
  default     = "redhat-openshift"
}
