# TODO: Migrate to minio combinator component

resource "helm_release" "minio" {
  repository       = "https://helm.min.io/"
  chart            = "minio"
  version          = "8.0.9"
  name             = "${var.name_prefix}-minio"
  namespace        = var.namespace
  wait             = true
  create_namespace = true
  lint             = true
  force_update     = true

  values = [
    yamlencode({ accessKey = "minio"
      secretKey            = "minio123" # pragma: allowlist secret
      generate-name        = "minio/minio"
      service = {
        port = 9000
      }
      resources = {
        requests = {
          memory = "256Mi"
        }
      }
      buckets = [{
        name   = "mlflow-artifacts"
        policy = "none"
        purge  = "false"
      }]
    })
  ]
}
