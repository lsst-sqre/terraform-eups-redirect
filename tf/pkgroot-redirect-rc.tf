locals {
  log_sidecar_image = "busybox"
  www_server        = "nginx"
  www_log_root      = "/var/log/nginx"
  redirect_host     = "eups-redirect.lsst.codes"
  www_log_access    = "${local.www_log_root}/${local.redirect_host}.access.log"
  www_log_error     = "${local.www_log_root}/${local.redirect_host}.error.log"

  www_log_mount = {
    name       = "${local.www_server}-logs"
    mount_path = "${local.www_log_root}"
  }
}

resource "kubernetes_replication_controller" "pkgroot_redirect" {
  metadata {
    namespace = "${var.k8s_namespace}"
    name      = "redirect-rc"

    labels {
      name = "redirect-rc"
    }
  }

  spec {
    selector {
      name = "redirect-rc"
    }

    replicas = 1

    template {
      container {
        name              = "redirector"
        image             = "docker.io/lsstsqre/eupsredirector"
        image_pull_policy = "Always"

        port {
          name           = "redirector"
          container_port = 80
        }

        volume_mount = ["${local.www_log_mount}"]
      } # container

      # https://kubernetes.io/docs/concepts/cluster-administration/logging/#streaming-sidecar-container
      container {
        name  = "${local.www_server}-access"
        image = "${local.log_sidecar_image}"
        args  = ["/bin/sh", "-c", "tail -n+1 -f ${local.www_log_access}"]

        volume_mount = ["${local.www_log_mount}"]
      } # container

      container {
        name  = "${local.www_server}-error"
        image = "${local.log_sidecar_image}"
        args  = ["/bin/sh", "-c", "tail -n+1 -f ${local.www_log_error}"]

        volume_mount = ["${local.www_log_mount}"]
      } # container

      volume {
        name      = "${local.www_log_mount["name"]}"
        empty_dir = {}
      }
    } # template
  } # spec
}
