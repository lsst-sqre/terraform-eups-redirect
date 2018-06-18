resource "kubernetes_namespace" "pkgroot_redirect" {
  metadata {
    name = "${var.k8s_namespace}"
  }
}
