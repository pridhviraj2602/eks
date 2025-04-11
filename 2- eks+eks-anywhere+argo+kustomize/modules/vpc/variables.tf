variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "subnet_cidrs" {
  description = "List of subnet CIDR blocks"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
}
