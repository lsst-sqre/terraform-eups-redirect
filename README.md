terraform `pkgroot-redirect` module
===

[![Build Status](https://travis-ci.org/lsst-sqre/terraform-eups-redirect.png)](https://travis-ci.org/lsst-sqre/terraform-eups-redirect)

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

      k8s_namespace              = "pkgroot-redirect"
      k8s_host                   = "${module.gke.host}"
      k8s_client_certificate     = "${module.gke.client_certificate}"
      k8s_client_key             = "${module.gke.client_key}"
      k8s_cluster_ca_certificate = "${module.gke.cluster_ca_certificate}"
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

