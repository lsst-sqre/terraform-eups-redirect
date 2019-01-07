terraform `pkgroot-redirect` module
===

[![Build Status](https://travis-ci.org/lsst-sqre/terraform-pkgroot-redirect.png)](https://travis-ci.org/lsst-sqre/terraform-pkgroot-redirect)

Kubernetes deployment of an nginx server that redirects `sw.lsstcorp.org` to
`eups.lsst.codes`.

Usage
---

    module "pkgroot-redirect" {
      source       = "github.com/lsst-sqre/terraform-pkgroot-redirect//tf?ref=master"
      aws_zone_id  = "${var.aws_zone_id}"
      env_name     = "${var.env_name}"
      service_name = "eups-redirect"
      domain_name  = "${var.domain_name}"

      k8s_namespace = "pkgroot-redirect"

      proxycert = "${file(".../sw.lsstcorp.org.20170530_chain.pem")}"
      proxykey  = "${file(".../sw.lsstcorp.org.20170530.key")}"
      dhparam   = "${file(".../dhparam.pem")}"
    }

Outputs
---

None.

Resources created
---

* `kubernetes_service.ssl_proxy`
* `aws_route53_record.pkgroot_redirect_www`
* `kubernetes_replication_controller.pkgroot_redirect`
* `kubernetes_namespace.pkgroot_redirect`
* `kubernetes_replication_controller.ssl_proxy`
* `kubernetes_service.pkgroot_redirect`
* `kubernetes_secret.ssl_proxy`

See Also
---

* [`terraform`](https://www.terraform.io/)

