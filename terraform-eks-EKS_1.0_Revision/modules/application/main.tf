resource "kubernetes_deployment" "app" {
  metadata {
    name      = var.application
    namespace = "default"
    labels = {
      app = var.application
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = var.application
      }
    }

    template {
      metadata {
        labels = {
          app = var.application
        }
      }

      spec {
        container {
          name  = var.application
          image = var.application_image
          ports {
            container_port = 80
          }
        }
      }
    }
  }
}