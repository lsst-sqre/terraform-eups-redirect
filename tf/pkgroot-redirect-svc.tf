resource "kubernetes_service" "pkgroot_redirect" {
  metadata {
    namespace = "${var.k8s_namespace}"
    name      = "redirect-svc"

    labels {
      name = "redirect-svc"
    }
  }

  spec {
    selector {
      name = "redirect-rc"
    }

    port {
      name = "http"
      port = 80

      target_port = 80
      protocol    = "TCP"
    }
  } # spec
}
