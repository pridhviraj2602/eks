variable "region" {}
variable "env" {}   # IL2 or IL5
variable "cluster_name" {}
variable "vpc_cidr" {}
variable "subnet_cidrs" {
  type = list(string)
}

locals {
  env_cluster = "${var.env}-${var.cluster_name}"
}