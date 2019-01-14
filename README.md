terraform `pkgroot-redirect` module
===

[![Build Status](https://travis-ci.org/lsst-sqre/terraform-pkgroot-redirect.png)](https://travis-ci.org/lsst-sqre/terraform-pkgroot-redirect)

Kubernetes deployment of an nginx server that redirects `sw.lsstcorp.org` to
`eups.lsst.codes`.

Usage
---

See [terraform-doc output](tf/README.md) for available arguments and
attributes.

```hcl
module "pkgroot_redirect" {
  source       = "github.com/lsst-sqre/terraform-pkgroot-redirect//tf?ref=master"
  aws_zone_id  = "${var.aws_zone_id}"
  env_name     = "${var.env_name}"
  service_name = "eups-redirect"
  domain_name  = "${var.domain_name}"
  dns_enable   = false

  k8s_namespace = "pkgroot-redirect"

  proxycert = "${file(".../sw.lsstcorp.org.20170530_chain.pem")}"
  proxykey  = "${file(".../sw.lsstcorp.org.20170530.key")}"
  dhparam   = "${file(".../dhparam.pem")}"
}
```

`pre-commit` hooks
---

```bash
go get github.com/segmentio/terraform-docs
pip install --user pre-commit
pre-commit install

# manual run
pre-commit run -a
```

See Also
---

* [`terraform`](https://www.terraform.io/)
* [`terragrunt`](https://github.com/gruntwork-io/terragrunt)
* [`terraform-docs`](https://github.com/segmentio/terraform-docs)
* [`pre-commit`](https://github.com/pre-commit/pre-commit)
* [`pre-commit-terraform`](https://github.com/antonbabenko/pre-commit-terraform)
