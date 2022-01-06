resource "helm_release" "database" {
  depends_on       = [kubernetes_secret.database_password]
  repository       = local.database_chart_repository
  chart            = local.database_chart_name
  version          = local.database_chart_version
  name             = "${var.name_prefix}-database"
  namespace        = var.namespace
  wait             = true
  create_namespace = true
  lint             = true
  force_update     = true

  values = [
    yamlencode(local.database_values)
  ]
}

# resource "kubernetes_secret" "database_password" {
#   metadata {
#     name      = "${var.name_prefix}-mlflow-mysql" # TODO hardcoded name
#     namespace = var.namespace
#   }
#   data = {
#     password = "mlflow123" # TODO: Generate passwords # pragma: allowlist secret
#   }
# }