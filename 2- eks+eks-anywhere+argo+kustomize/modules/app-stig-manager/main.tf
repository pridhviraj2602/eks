variable "cluster_name" {
  description = "EKS cluster ID"
  type        = string
}

variable "db_endpoint" {
  description = "Database endpoint for Stig Manager"
  type        = string
}

variable "db_username" {
  description = "Database username for Stig Manager"
  type        = string
}

variable "db_password" {
  description = "Database password for Stig Manager"
  type        = string
}

resource "helm_release" "stig_manager" {
  name             = "stig-manager"
  repository       = "https://charts.example.com/stigmanager"  # Replace with your actual chart repo
  chart            = "stig-manager"
  create_namespace = true
  namespace        = "stig-manager"

  set {
    name  = "database.type"
    value = "mysql"
  }
  set {
    name  = "database.host"
    value = var.db_endpoint
  }
  set {
    name  = "database.user"
    value = var.db_username
  }
  set {
    name  = "database.password"
    value = var.db_password
  }
  set {
    name  = "database.name"
    value = "stigdb"
  }
}
