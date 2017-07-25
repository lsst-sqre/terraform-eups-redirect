terraform {
  backend "s3" {}
}

resource "aws_route53_record" "eups-redirect-www" {
  zone_id = "${var.aws_zone_id}"

  # remove "<env>-" prefix for production
  name    = "${replace("${var.env_name}-eups-redirect.${var.domain_name}", "prod-", "")}"
  type    = "A"
  ttl     = "300"
  records = ["${trimspace(file("../../kubernetes/service_ip.txt"))}"]
}
