variable "cluster_name" {
  description = "EKS cluster ID"
  type        = string
}

variable "db_endpoint" {
  description = "Database endpoint for Heimdall"
  type        = string
}

variable "db_username" {
  description = "Database username for Heimdall"
  type        = string
}

variable "db_password" {
  description = "Database password for Heimdall"
  type        = string
}

resource "helm_release" "heimdall" {
  name             = "heimdall"
  repository       = "https://charts.example.com/heimdall"  # Replace with your actual chart repo
  chart            = "heimdall"
  create_namespace = true
  namespace        = "heimdall"

  set {
    name  = "database.type"
    value = "postgresql"
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
    value = "heimdalldb"
  }
}
