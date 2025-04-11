variable "cluster_name" {
  description = "EKS cluster ID"
  type        = string
}

variable "db_endpoint" {
  description = "Database endpoint for Keycloak"
  type        = string
}

variable "db_username" {
  description = "Database username for Keycloak"
  type        = string
}

variable "db_password" {
  description = "Database password for Keycloak"
  type        = string
}

resource "helm_release" "keycloak" {
  name             = "keycloak"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "keycloak"
  create_namespace = true
  namespace        = "keycloak"

  set {
    name  = "postgresql.enabled"
    value = "false"
  }
  set {
    name  = "externalDatabase.host"
    value = var.db_endpoint
  }
  set {
    name  = "externalDatabase.user"
    value = var.db_username
  }
  set {
    name  = "externalDatabase.password"
    value = var.db_password
  }
  set {
    name  = "externalDatabase.database"
    value = "keycloakdb"
  }
}
