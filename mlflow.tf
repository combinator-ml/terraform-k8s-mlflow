resource "helm_release" "mlflow" {
  depends_on       = [helm_release.database, helm_release.minio]
  repository       = local.mlflow_chart_repository
  chart            = local.mlflow_chart_name
  name             = "${var.name_prefix}-mlflow"
  namespace        = var.namespace
  wait             = true
  create_namespace = true
  lint             = true
  force_update     = true

  values = [
    yamlencode(local.mlflow_values)
  ]
}
