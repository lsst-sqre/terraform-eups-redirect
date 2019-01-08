resource "aws_route53_record" "pkgroot_redirect_www" {
  zone_id = "${var.aws_zone_id}"

  name    = "${local.fqdn}"
  type    = "A"
  ttl     = "300"
  records = ["${kubernetes_service.ssl_proxy.load_balancer_ingress.0.ip}"]
}
