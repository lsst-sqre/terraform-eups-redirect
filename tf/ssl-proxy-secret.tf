resource "kubernetes_secret" "ssl_proxy" {
  metadata {
    namespace = "${var.k8s_namespace}"
    name      = "ssl-proxy-secret"
  }

  data {
    proxycert = "${file("${path.root}/lsst-certs/lsst.codes/sw.lsstcorp.org/sw.lsstcorp.org.20170530_chain.pem")}"
    proxykey  = "${file("${path.root}/lsst-certs/lsst.codes/sw.lsstcorp.org/sw.lsstcorp.org.20170530.key")}"
    dhparam   = "${file("${path.root}/dhparam.pem")}"
  }
}
