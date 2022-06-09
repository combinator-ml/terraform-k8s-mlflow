locals {
  mlflow_chart_repository = "${path.module}/helm-mlflow"
  mlflow_chart_name       = "mlflow"
  mlflow_values = {
    backendStore = {
      mysql = {
        username = "mlflow"
        password = "mlflow123" # TODO: Generate passwords # pragma: allowlist secret
        host     = "${var.name_prefix}-database-mysql.${var.namespace}.svc.cluster.local"
        port     = 3306
        database = "mlflow"
      }
    }
    awsAccessKeyId      = "minio"    # module.minio.CONSOLE_ACCESS_KEY
    awsSecretAccessKey  = "minio123" # module.minio.CONSOLE_SECRET_KEY # pragma: allowlist secret
    s3EndpointUrl       = "http://${var.name_prefix}-minio.${var.namespace}.svc.cluster.local:9000"
    defaultArtifactRoot = "s3://mlflow-artifacts/"
  }
  database_chart_repository = "https://charts.bitnami.com/bitnami"
  database_chart_name       = "mysql"
  database_chart_version    = "8.9.6"
  database_values = {
    auth = {
      rootPassword = "mysql123" # TODO: Generate passwords # pragma: allowlist secret
      database     = "mlflow"
      username     = "mlflow"
      password     = "mlflow123" # TODO: Generate passwords # pragma: allowlist secret
    }
  }
}
