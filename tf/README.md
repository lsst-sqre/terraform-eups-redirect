# terraform-pkgroot-redirect

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_default\_region | AWS region to launch servers. | string | `"us-east-1"` | no |
| aws\_zone\_id | route53 Hosted Zone ID to manage DNS records in. | string | n/a | yes |
| dhparam |  | string | n/a | yes |
| domain\_name | DNS domain name to use when creating route53 records. | string | n/a | yes |
| env\_name | Name of deployment environment. | string | n/a | yes |
| k8s\_namespace | k8s namespace to manage resources within. | string | `"pkgroot"` | no |
| proxycert |  | string | n/a | yes |
| proxykey |  | string | n/a | yes |
| service\_name | service / unqualifed hostname | string | `"eups-redirect"` | no |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

