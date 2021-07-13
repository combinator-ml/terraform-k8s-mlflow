variable "namespace" {
  description = "(Optional) The namespace to install into."
  type        = string
  default     = "mlflow"
}

resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.namespace
  }
}

module "mlflow" {
  source    = "combinator-ml/mlflow/k8s"
  namespace = var.namespace
}

module "jupyter" {
  depends_on = [kubernetes_namespace.namespace]
  source     = "combinator-ml/jupyter/k8s"
  version    = "0.0.3"
  namespace  = var.namespace
}

resource "kubernetes_service" "mlflow_external" {
  metadata {
    name      = "mlflow-external"
    namespace = var.namespace
  }
  spec {
    selector = {
      "app.kubernetes.io/instance" = "mlflow"
      "app.kubernetes.io/name"     = "mlflow"
    }
    type = "NodePort"
    port {
      node_port   = 30600
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_service" "minio_external" {
  metadata {
    name      = "minio-external"
    namespace = var.namespace
  }
  spec {
    selector = {
      "app"     = "minio"
      "release" = "minio"
    }
    type = "NodePort"
    port {
      node_port   = 30650
      port        = 9000
      target_port = 9000
    }
  }
}

resource "kubernetes_service" "jupyter" {
  metadata {
    name      = "jupyter-external"
    namespace = var.namespace
  }
  spec {
    selector = {
      app = "combinator-jupyter"
    }
    port {
      name        = "http"
      port        = 8888
      target_port = 8888
      node_port   = 31380
    }
    type = "NodePort"
  }
}
