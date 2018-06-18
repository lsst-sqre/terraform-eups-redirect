resource "kubernetes_replication_controller" "ssl_proxy" {
  metadata {
    namespace = "${var.k8s_namespace}"
    name      = "nginx-ssl-proxy"

    labels {
      name = "nginx-ssl-proxy"
      role = "ssl-proxy"
    }
  }

  spec {
    replicas = 1

    selector {
      name = "nginx-ssl-proxy"
      role = "ssl-proxy"
    }

    template {
      container {
        name  = "nginx-ssl-proxy"
        image = "docker.io/lsstsqre/nginx-ssl-proxy:latest"

        env {
          name  = "SERVICE_HOST_ENV_NAME"
          value = "REDIRECT_SVC_SERVICE_HOST"
        }

        env {
          name  = "SERVICE_PORT_ENV_NAME"
          value = "REDIRECT_SVC_SERVICE_PORT_HTTP"
        }

        env {
          name  = "ENABLE_SSL"
          value = "true"
        }

        env {
          name  = "ENABLE_BASIC_AUTH"
          value = "false"
        }

        port {
          name           = "ssl-proxy-http"
          container_port = 80
        }

        port {
          name           = "ssl-proxy-https"
          container_port = 443
        }

        volume_mount {
          name       = "secrets"
          mount_path = "/etc/secrets"
          read_only  = true
        }
      } # container

      volume {
        name = "secrets"

        secret {
          secret_name = "ssl-proxy-secret"
        }
      }
    } # template
  } # spec

  depends_on = ["kubernetes_secret.ssl_proxy"]
}
